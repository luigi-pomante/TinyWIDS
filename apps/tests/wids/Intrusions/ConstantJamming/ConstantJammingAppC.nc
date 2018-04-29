
#include "TKN154.h"
#include "printf.h"

configuration ConstantJammingAppC {

} implementation {

	components ConstantJammingC as Jammer, MainC, RandomC;
	components SerialPrintfC;
	components Ieee802154BeaconEnabledC as MAC;
	components LedsC;

	Jammer.Leds -> LedsC;
	Jammer.Boot -> MainC;
	Jammer.Transmit -> MAC;
	Jammer.Random -> RandomC;
	Jammer.MLME_RESET -> MAC;
}
