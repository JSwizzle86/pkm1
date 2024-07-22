There's a lot of shit I did not do. I can't really do the whole thing as I said. It requires me to be a bigger part of the 
project than I want to be honestly. There's a lot of other stuff I want to do too.

Here's what I did not do.
1) The dex menu does scroll, but you can't really see that right now. There's no scrollwheel and the entire dex is
comprised of 12 meganiums. Go to the FakePokedex node and set it as an autoload so that it works in the main project.
It also doesn't transition. You just need to move the dex data, and you can use the index of the focused node.
2) I didn't get the clipping right on the map, so it looks wack.
3) The habitat map is entirely unusable, I have the autotile set up for the tilemap. You'll have to do the rest. I suggest
recoloring it white and doing shader shit.
4) You can't get to the other menus since the transition isn't really done. It's not far from being done.

Really you just have to set the menus up in the right sequence in the array and loop through it using Input.get_axis and
wrap().

The good news is that the scrolling menu looks really good.
- The Battle Dex ui follows the reference. Really all you have to do is move the information around all of the names, titles,
weight, height, footprint, minisprite and high_res_sprite stuff is done and in place.

Definitely replace the font and readjust the boxes to make it look good again. Like, make yourself a quality gsc font.
I pulled that shit off of some website.