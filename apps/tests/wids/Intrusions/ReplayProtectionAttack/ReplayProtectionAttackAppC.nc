#include "TKN154.h"
#include "printf.h"
configuration ReplayProtectionAttackAppC {

} implementation {

	components ReplayProtectionAttackC as App, MainC;
	components SerialPrintfC;
	components Ieee802154BeaconEnabledC as MAC, new Timer62500C() as Timer;

	App.Boot -> MainC;
	App.RadioRx -> MAC;
	App.RadioOff -> MAC;
	App.RadioTx -> MAC;
	App.IEEE154Frame -> MAC;
	App.MLME_RESET -> MAC;
	App.ResendTimer -> Timer;
}