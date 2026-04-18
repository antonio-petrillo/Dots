package main

import "core:fmt"
import "core:os"
import "vendor:x11/xlib"

main :: proc() {
	display := xlib.OpenDisplay(nil)

	if display == nil {
		fmt.eprintfln("Can't open display")
		os.exit(-1)
	}

	state: xlib.XkbStateRec
	status := xlib.XkbGetState(display, xlib.XkbUseCoreKbd, &state)

	/* #partial switch status { */
	/* case .Success: */
	/* 	//ok */
	/* 	fmt.println(state) */
	/* case: */
	/* 	fmt.eprintln("XkbGetState failed:", status) */
	/* 	os.exit(-1) */
	/* } */

	if status != .Success {
		fmt.eprintln("XkbGetState failed:", status)
		os.exit(-1)
	}

	// NOTE(Nto):  hardcoded, this is just for my machine so who cares
	groups := [2]string{"us", "us(intl)"}

	if state.group > 1 {
		fmt.eprintfln("Keyboard group out of bound: %d", state.group)
	}
	fmt.print(groups[state.group])
}
