

module DummyP {
	provides interface TimeCalc;
	provides interface FrameUtility;
} implementation {

	async command uint32_t TimeCalc.timeElapsed(uint32_t t0, uint32_t t1){
		return 1;
	}

	async command bool TimeCalc.hasExpired(uint32_t t0, uint32_t dt){
		return TRUE;
	}

	async command uint8_t FrameUtility.writeHeader(
      uint8_t* mhr,
      uint8_t DstAddrMode,
      uint16_t DstPANId,
      ieee154_address_t* DstAddr,
      uint8_t SrcAddrMode,
      uint16_t SrcPANId,
      const ieee154_address_t* SrcAddr,
      bool PANIDCompression){

	}

	
	async command error_t FrameUtility.getMHRLength(uint8_t fcf1, uint8_t fcf2, uint8_t *len){
		*len = 0;
	}

	
	command bool FrameUtility.isBeaconFromCoord(message_t *frame){
		return FALSE;
	}

	
	async command void FrameUtility.copyLocalExtendedAddressLE(uint8_t *destLE){

	}

	
	command void FrameUtility.copyCoordExtendedAddressLE(uint8_t *destLE){

	}


	async command void FrameUtility.convertToLE(uint8_t *destLE, const uint64_t *srcNative){

	}


	async command void FrameUtility.convertToNative(uint64_t *destNative, const uint8_t *srcLE){

	}
}