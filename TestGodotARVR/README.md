# Test project for Godot AR/VR server
This is a test/demo project to show a boiler plate VR game in Godot.

Setup
======
Right now when this project starts it picks the last AR/VR interface off the list. What this really needs is a setup window that allows you to choose and if required configure the interface. I hope to have time for this soon.

Viewports
============
One of the latest changes we applied to the AR/VR server implementation is that it can take over rendering of the main viewport by simply turning the ar/vr mode on on the main viewport like so:
get_viewport().arvr = true

This is in fact mandatory for interfaces like our mobile interface as it needs to render to the main output.

For OpenVR the render output is redirected directly to the HMD. If the main viewport is used the left eye will be rendered to screen but if you use a separate viewport this does not happen and you control the output to screen yourself. This allows for implementing a spectator camera or allows for creating a co-op game where one player plays on the HMD and the other sits behind the monitor.

Test scene
============
Note that the bar scene is a place holder for now. I'm looking for a larger and more interesting scene that you can actually move around in and that I can include without getting sued :)
If anyone wants to donate one, let me know, i'm not much of a 3D artist
