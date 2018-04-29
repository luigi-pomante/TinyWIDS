#define PERIOD

module EvaluationC {
	provides interface Notify<wids_observable_t>;
	uses interface Timer<TSymbolIEEE802154>;
	uses interface Random;
	uses interface Boot;
} implementation {

	uint8_t notify[6][5] = {
		{1, 2, 1, 3, 1}, {2, 3, 10, 9, 5}, {5, 2, 1, 3, 9},
		{0, 2, 0, 0, 0}, {6, 7, 4, 5, 6}, {7, 8, 0, 9, 9}
	};


	event void Boot.booted(){
		call Timer.startPeriodic(200);
	}

	command error_t Notify.enable() {
		return SUCCESS;
	}
	
	command error_t Notify.disable() {
		return SUCCESS;	
	}

	event void Timer.fired(){
		uint8_t i = call Random.rand16() % 6, j=0;
		while(j < 5){
			signal Notify.notify(notify[i][j]);
			j++;
		}
	}
}