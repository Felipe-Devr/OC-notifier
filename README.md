## OC Notifier

OC Notifier is a OpenComputers script that allow you to get notification of some events that may happen in your minecraft world.

![Example Notification](/public/notification.png)

## Bare Minimum Components
- Tier 3 Computer Case
- Tier 1 Screen
- Tier 1.5 Memory
- Tier 1 Central Processing Unit
- Tier 2 Graphics Card
- Tier 1 Hard Disk Drive
- Internet Card
- EEPROM (Lua BIOS)
- OpenOS Floppy Disk
- Adapter
- 1+ Cables

![Screenshot of the bareminimum computer requirements](/public/bareminimum.png)

## Quick Start
1. Place the adapter next to the ME Controller
2. Connect the adapter, computer case and screen (Place the keyboard next to the screen) with open computers cables.
3. Power everything by connecting a GregTech/AE2 cable directly to the computer case. Alternatively, use a power converter.
4. Add all the components into the computer case and turn it on.
5. Follow the instructions on the screen and type install -> Y -> Y
6. Install the required scripts by using the following command.
```
wget https://raw.githubusercontent.com/Felipe-Devr/OC-notifier/main/init.lua && init
```

7. Edit the config file by entering `edit config.lua`, there you need to provide a webhook url
![Where to copy the webhook URL](/public/webhook.png)
> [How to create a Discord Webhook](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks)

![Example Setup](/public/example_setup.png)

## Running The Program
Launch the notifier by typing `notifier`. The script runs indefinitely until manually terminated by the player pressing 'Ctrl-Alt + C' in the terminal. Restarting the computer also works.


## TODO list
- [x] AE2 Crafting notifications
- [ ] Needs Maintenance notifications
