# Discontinuation

I didn't want to do this, but BlitzMax appears to be dead... The original compiler refuses to work on all three platforms, and BlitzMax NG refuses to create code the GCC linker likes. I've moved on to C# for most of my work, as I cannot compile any of these anymore. If you hsee interesting stuff here... Feel free to fork it if you wanna continue these, the license terms remain the same as they were.

I'm sorry about this, but given the circumstances I've no more choice but to go this way...

# Tricky's modules for BlitzMax

I wrote these modules for my own benefit, however if you have use for them, go ahead, use them as you please, however before you do, please read the license terms which should be included in each module.

Please note, this repository is updated real-time as soon as the tiniest update is done my building script will update this repository automatically. Therefore I can never guarantee these updates work the way they should. Always keep that in mind.



If reporting a bug or any other issue, keep the next stuff in mind.

1. Make sure I'm not working on the module in question. If a module is updated less than 24h ago I might still be working on the specific module.
2. When it comes to time, the time zone specified in the update note is CET. Of course, the GitHub time notice might be more accurate as GitHub as GitHub takes timezones into account ;)
3. NEVER forget WHICH specific module contains the bug or any other kind of issue. It makes my life a lot easier if I don't have to check all modules to find out what you are talking about.

As of 6/11/2016 (US notation), all modules SHOULD be supported by Brucey's BlitzMax NG. If there is any trouble in getting that compiled, please lemme know.

One note for Linux users:
Windows is case-insensitive, and Mac can allow case-insensitivity. My work device was ExFAT formatted, which is case-insensitive. Linux users should therefore be aware of the fact that when BlitzMax is installed on a Linux formatted device some modules may fail to build. Case mismatches were simply ignored by my compiler when compiling for Mac and Windows, and that is what I do most, and thus you may suffer a little when compiling on Linux as I don see these errors.
Whenever you see Linux acting up because of this, don't hesitate to report it as a "bug".
Unfortunately git/github will not change the casing in the files when I do. Fortunately this repository is only a copy of my actual work code, and thus I can "fix" that be erasing everything in the repository and resubmitting that, but sometimes I might forget that, so don't kill me when I deem a case issue in Linux "fixed" and the repository doesn't take that over. That is a Git/GitHub issue. :(
Sorry for any inconvience.

Final note:
You may modify these modules as you please as long as its in accordance with the license set up for that module. It's however not a good idea to upload your modified versions to this repository (even if you only did a bugfix). This repository is only a copy of my real stuff, and thus my next update will very likely overwrite your modifications (my builder is completely automated and merciless, I'm sorry).
