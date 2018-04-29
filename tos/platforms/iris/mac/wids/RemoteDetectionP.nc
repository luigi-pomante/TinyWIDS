

module RemoteDetectionP {
	
	provides interface Notify<wids_observable_t> as RemoteOutput;

	uses interface Notify<wids_attack_t> as RemoteInput;

} implementation {
	
	command error_t RemoteOutput.enable() {
		return SUCCESS;
	}
	
	command error_t RemoteOutput.disable() {
		return SUCCESS;	
	}

	event void RemoteInput.notify(wids_attack_t att){
		wids_observable_t obs;
		printf("Remote attack: %s\n", printfAttack(att));
		switch(att){
			case NO_ATTACK:
				obs = OBS_NONE;
			case CONSTANT_JAMMING:
				obs = OBS_16;
			case DECEPTIVE_JAMMING:
				obs = OBS_17;
			case REACTIVE_JAMMING:
				obs = OBS_18;
			case RANDOM_JAMMING:
				obs = OBS_19;
			case LINKLAYER_JAMMING:
				obs = OBS_20;
			case BACKOFF_MANIPULATION:
				obs = OBS_21;
			case REPLAYPROTECTION_ATTACK:
				obs = OBS_22;
			case GTS_ATTACK:
				obs = OBS_23;
			case ACK_ATTACK:
				obs = OBS_26;
			case SELECTIVE_FORWARDING:
				obs = OBS_27;
			case SINKHOLE:
				obs = OBS_28;
			case SYBIL:
				obs = OBS_29;
			case WORMHOLE:
				obs = OBS_30;
			case HELLO_FLOODING:
				obs = OBS_27;
			default:
				obs = OBS_NONE;
		}
		signal RemoteOutput.notify(obs);
	}

}