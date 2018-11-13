# OSC
Open Sound Control for interactive systems
---
Open Sound Control is a networking protocol designed with interactive real-time applications in mind. It was originally designed for sound, as a replacement of MIDI in modern networks, but over the years it has become very broadly supported in all kinds of interactive scenarios that do not necessarily involve sound.
---
It allows you to send data from one program to another. Really fast and very easily.
---
## Open Sound Control
- is open-ended (you can send any kind of data)
- is very robust
- very light-weight (requires less processing than JSON/REST for example e.g. no webserver)
- is symbolic (you can send messages that aren't just a binary jumble)
- very easy to use and learn
- OSC messages are human-readable
---
## Open Sound Control
- very broadly supported (most programming languages have OSC implementations and most software for real-time digital content supports OSC)
- easy to debug (so you spend less time trying to find mistakes)

---
## OSC applications
- Real-time sensor interfaces
- Gesture-based electronic music instruments
- Mapping non-musical data to audiovisuals
- Web interfaces
- Telepresence
- Virtual Reality
- Physical interfaces
- Generic controllers
- Stage hardware for light/sound control
---
## OSC is based on the UDP/IP protocol
this means that it can also work over the Internet (think about what that means for a second)
---
## OSC support
Most audiovisual performance or composition software supports OSC or has an OSC plugin. PureData,MAX/MSP, TouchDesigner, vvvv, Resolume, Ableton Live, Iannix, etc. It's a very long list.
---
### Anatomy of an OSC message

OSC messages all have an address and a series of parameters, and they look like this:

```
/mymixer/slider/1 127
```

```
/mymixer/knob/2 64
```

the first part is called the _address_ and the second is called the _parameter_
---
### Anatomy of an OSC message

Each _address_ can have as many parameters as you like. For example, imagine that our controller has 8 sliders, we can send the state of all sliders in a single message, like this.

```
/mymixer/sliders 123 45 67 89 77 465 343 333
```
---
### Anatomy of an OSC message
Parameters can be of different types: integer numbers (i), floats (f), strings (s), binary blobs (b). And that's it, those are all the basic types you will ever encounter...

---
### Anatomy of an OSC message

In our message map we can say that we want to have a message for all sliders that looks like:

```
/mymixer/sliders iiiiiiii
```

Out of which one example would be this message we saw before:

```
/mymixer/sliders 123 45 67 89 77 465 343 333
```

---
### Love OSC because...

There are many reasons to love OSC, but by far the one reason I find relevant to you is that
it allows you to decouple the interaction from the result of that interaction. Enabling you to
test different interactions quickly without having to change the outcome. So it nables two design/make processes to be made in parallel, potentially by different people. All they have to do is agree on the protocol.
---
### Love OSC because...

You can build the sensing part of your project, separately from your actuation part (or viz or sound).
---
### Love OSC because...
It's so widely supported, that you don't need to build a parser for it
---
### Love OSC because...
It just works!
---
### OSC is flexible
it allows you to define your own protocol, or rather a human-readable _message map_.
---
# Example
blowing into a microphone as an interaction
---
# Example
Let's build it!


