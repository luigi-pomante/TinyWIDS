

module NetworkAdapterP {

	provides interface NetworkUtility;

} implementation {

	command bool NetworkUtility.isClusterHead() {
		if(TOS_NODE_ID == 0)
			return TRUE;
		else
			return FALSE;
	}

	command bool NetworkUtility.isMyAddress(uint16_t *addr) {
		return *addr == TOS_NODE_ID;
	}

	command uint16_t* NetworkUtility.getNextHop(uint16_t *addr) {
		uint16_t a = 0;
		return &a;
	}

	command bool NetworkUtility.isAuthenticated(uint16_t *address) {
		return TRUE;
	}

	command void NetworkUtility.getSrcAddr(message_t *msg, uint16_t* addr) {

	}
	
	command void NetworkUtility.getDstAddr(message_t *msg, uint16_t* addr) {

	}

	command uint8_t NetworkUtility.getFrameType(message_t *msg){
		 return MHR(msg)[MHR_INDEX_FC1] & FC1_FRAMETYPE_MASK;
	}

	command void NetworkUtility.getCHAddr(uint16_t* addr) {

	}

}