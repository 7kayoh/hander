# Hander
Simple and open sourced hand-to utility, for your roleplay game's needs.

## Getting Started
To build the place from scratch, use:

```bash
rojo build -o "Hander.rbxlx"
```

Next, open `Hander.rbxlx` in Roblox Studio and start the Rojo server:

```bash
rojo serve
```

## Setting up feedback
By default, Hander do not send any feedback back to the user, and the person who received the tool. To implement feedbacks, you can connect the RemoteEvent Hander uses, which is `Hander_Event`. After that, simply check whether the first parameter is `receive`, if so, the second parameter will be: `{client's name, tool's name}`.

To implement feedback for the original sender, simply just use the boolean returned by the RemoteFunction call inside `Shared.Cook.init.lua`, where true means successful, false means fail.

## Credits
Hander uses the following libraries/softwares:

- [EtiLibs/Logger](https://www.roblox.com/library/6600363372/EtiLibs)
- [EtiLibs/Lang](https://www.roblox.com/library/6600363372/EtiLibs)
- [Promise](https://github.com/evaera/roblox-lua-promise)
- [spr](https://github.com/Fraktality/spr/)
- [Matcher](https://github.com/rgieseke/textredux/blob/main/util/matcher.lua)
- [Rojo](https://rojo.space/)

## License
Hander is licensed under the MIT license, read it [here](./LICENSE)