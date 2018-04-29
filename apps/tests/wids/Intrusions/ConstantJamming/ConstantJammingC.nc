#include "TKN154.h"
#include "printf.h"
#include "app_profile.h"

module ConstantJammingC {
	
	uses interface Boot;
	uses interface Random;
	uses interface RadioTx as Transmit;
	uses interface MLME_RESET;
	uses interface Leds;

} implementation {

	ieee154_txframe_t *msg;
	
	uint8_t hLen = 10;
	uint8_t pLen = 100;

	void msgInit();
	task void jamming();

	event void MLME_RESET.confirm(ieee154_status_t status){
		
	}

	event void Boot.booted(){
		printf("Booted\n");
		msgInit();
	}

	//we use the random interface to write a message that we will send
	void msgInit(){
		uint8_t i = 0;
		uint8_t *buf;

		printf("msgInit\r\n");
		
		msg = malloc(sizeof(ieee154_txframe_t));

		msg->header = malloc(sizeof(ieee154_header_t));
		buf = MHR(msg);
		while(i<hLen){
			*buf = (uint8_t)call Random.rand16();
			buf++;
			i+=1;
		}
		msg->headerLen = hLen;

		msg->payload = 3;
		msg->payloadLen = 1;

		msg->metadata = malloc(sizeof(ieee154_metadata_t));
		msg->metadata->timestamp = 0;

		post jamming();
	}

	task void jamming(){
		error_t res = call Transmit.transmit(msg, 0, 0);
		//printf("jamming\n\r");
		call Leds.led2Toggle();
		if(res != SUCCESS) {
			if(res == EINVAL)
				printf("MSG FORMAT ERROR\n\r");
			printf("JAMMING ERROR: %X\n\r", res);
		}
	}

	async event void Transmit.transmitDone(ieee154_txframe_t *frame, error_t result){
		post jamming();
	}

}
