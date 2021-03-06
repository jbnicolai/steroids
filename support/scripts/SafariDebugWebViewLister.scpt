# Note: On both 10.8 and 10.9 it seems sufficient to merely LAUNCH Safari - no need to ACTIVATE it.
tell application "Safari" to launch

tell application "System Events"

	tell process "Safari"

		# Try to obtain a reference to the `Developer > {iPhone|iPad} Simulator`submenu items; give up after a while.
		set simSubMenu to missing value
		repeat with i from 1 to 20
			# Note that we reference the Developer menu by *index*, as its name may be localized.
			# Furthermore, we search for the relevant menu item by the tokens "iPhone" or "iPad" only, since the "Simulator" part could be localized, too.
			# Note that the menu-item name reflects whether the simulator currently simulates the iPhone or the iPad.
			tell (first menu item of menu -3 of menu bar 1 whose name contains "iPhone" or name contains "iPad" or name contains "iOS Simulator" )
				if exists then # Menu item found?
					# Simulate a click on the menu item so as to get it to populate its submenu with the currently debuggable pages.
					click it
					# Loop over submenu items and collect page URLs.
					set output to ""
					set pageUrl to missing value
					repeat with itm in menu items of menu of it
						set props to properties of itm # !! Bizarrely, this intermediate step is needed - directly accessing `help of itm` leads to strange behavior on OSX 10.8.
						set pageUrl to help of props # Page URL is in `help` property.
						if pageUrl is not missing value and pageUrl does not contain "Background/background.html" then
							set output to output & pageUrl & "
"
						end if
					end repeat
					# Return URLs.
					return output
				end if
			end tell
			delay 0.2 # Menu item not (yet) available; try again.
		end repeat

	end tell

	# Getting here means that the simulator menu item wasn't found within the timeout period.
	# Abort with an error.
	error "Cannot determine debuggable pages: iOS Simulator-related menu items not found in Safari.
Make sure that the `Developer` menu is activated in the advanced preferences and that the iOS simulator is running a UIWebView-based app."

end tell