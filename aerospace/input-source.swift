// input-source — switch the keyboard layout from the command line.
//
//   input-source                            # print the current layout id
//   input-source com.apple.keylayout.ABC    # switch to it
//
// Built by install.sh into ~/.local/bin/input-source:
//   swiftc -O ~/.config/aerospace/input-source.swift -o ~/.local/bin/input-source
import Carbon

guard let wanted = CommandLine.arguments.dropFirst().first else {
    let current = TISCopyCurrentKeyboardInputSource().takeRetainedValue()
    let id = Unmanaged<CFString>.fromOpaque(TISGetInputSourceProperty(current, kTISPropertyInputSourceID)).takeUnretainedValue()
    print(id)
    exit(0)
}

let filter = [kTISPropertyInputSourceID as String: wanted] as CFDictionary
guard let sources = TISCreateInputSourceList(filter, false)?.takeRetainedValue() as? [TISInputSource],
      let source = sources.first else {
    FileHandle.standardError.write("input-source: no layout \(wanted)\n".data(using: .utf8)!)
    exit(1)
}
exit(TISSelectInputSource(source) == noErr ? 0 : 1)
