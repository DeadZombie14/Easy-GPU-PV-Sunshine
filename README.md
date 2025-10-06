# Fork intended to enhance the gpu pv script by using Sunshine/Moonlight combo instead of Parsec.
Changes so far:
- Separate file to read parameters from (params.txt must exist)
- Script to easily clone a GPUPV VM. Instead of creating one from scratch.
- Script to show your host VMs IPs.
- Script to easily host an HTML file as a webpage with your host VMs IPs. Very useful, specially when dealing with IPv6 addresses.

Right now, after install, you must enter your ProgramData folder and execute each script individually. No automation. Make sure you have an internet connection.

Drivers
- Script to install sunshine
- Script to install the Virtual Display Driver from Miketech
- Script to regenerate the UUID of sunshine (Explanation: When cloning a VM, you want sunshine to tell moonlight its not the same machine as before, sadly sunshine hasnt implemente a GUI button for this)

TODO:
- Make the scripts work on boot (Sadly, I havent been able to make the scripts auto install on boot. Specially the VDDMTT one, since it requires special steps to add a virtual display. )
Just found about timminator/Enhanced-GPU-PV , he does the thing I want to do here as well. May take some "inspiration" to make my scripts work on boot haha.

- Implement a nice GUI like the one from chris titus script for easier control.
