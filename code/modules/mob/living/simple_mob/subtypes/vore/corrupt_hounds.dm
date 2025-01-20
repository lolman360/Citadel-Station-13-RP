/datum/category_item/catalogue/technology/drone/corrupt_hound		//TODO: VIRGO_LORE_WRITING_WIP
	name = "Drone - Corrupt Hound"
	desc = "A hound that has corrupted, due to outside influence, or other issues, \
	and occasionally garbles out distorted voices or words. It looks like a reddish-colored \
	machine, and it has black wires, cabling, and other small markings. It looks just like a station dog-borg \
	if you don't mind the fact that it's eyes glow a baleful red, and it's determined to kill you. \
	<br><br>\
	The hound's jaws are black and metallic, with a baleful red glow from inside them. It has a clear path \
	to it's internal fuel processor, synthflesh and flexing cabling allowing it to easily swallow it's prey. \
	Something tells you getting close or allowing it to pounce would be very deadly."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/vore/aggressive/corrupthound
	name = "corrupt hound"
	desc = "Good boy machine broke. This is definitely no good news for the organic lifeforms in vicinity."
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/corrupt_hound)

	icon_state = "badboi"
	icon_living = "badboi"
	icon_dead = "badboi-dead"
	icon_rest = "badboi_rest"
	icon = 'icons/mob/vore64x32.dmi'
	has_eye_glow = TRUE

	iff_factions = MOB_IFF_FACTION_HIVEBOT

	maxHealth = 200
	health = 200
	movement_sound = 'sound/effects/houndstep.ogg'

	legacy_melee_damage_lower = 5
	legacy_melee_damage_upper = 10 //makes it so 4 max dmg hits don't instakill you.
	grab_resist = 100
	taser_kill = 0 //This Mechanical Dog should probably not be harmed by tasers

	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = list("ravaged")
	friendly = list("nuzzles", "slobberlicks", "noses softly at", "noseboops", "headbumps against", "leans on", "nibbles affectionately on")

	base_pixel_x = -16

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 150
	maxbodytemp = 900

	say_list_type = /datum/say_list/corrupthound
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/evasive/corrupthound

	buckle_max_mobs = 1 //Yeehaw
	buckle_allowed = TRUE
	buckle_flags = BUCKLING_NO_USER_BUCKLE_OTHER_TO_SELF
	buckle_lying = FALSE


	loot_list = list(/obj/item/borg/upgrade/syndicate = 6, /obj/item/borg/upgrade/vtec = 6, /obj/item/material/knife/ritual = 6, /obj/item/disk/nifsoft/compliance = 6)

/mob/living/simple_mob/vore/aggressive/corrupthound/prettyboi
	name = "corrupt corrupt hound"
	desc = "Bad boy machine broke as well. Seems an attempt was made to achieve a less threatening look, and this one is definitely having some conflicting feelings about it."
	icon_state = "prettyboi"
	icon_living = "prettyboi"
	icon_dead = "prettyboi-dead"
	icon_rest = "prettyboi_rest"

	attacktext = list("malsnuggled","scrunched","squeezed","assaulted","violated")

	say_list_type = /datum/say_list/corrupthound_prettyboi

/mob/living/simple_mob/vore/aggressive/corrupthound/sniper
	name = "sniper hound"
	desc = "Good boy machine broke and its got a sniper rifle built in. This is no good news for anyone in range."
	icon_state = "sniperboi"
	icon_living = "sniperboi"
	icon_dead = "sniperboi-dead"
	icon_rest = "sniperboi_rest"

	base_attack_cooldown = 60

	projectiletype = /obj/projectile/beam/sniper
	projectilesound = 'sound/weapons/gauss_shoot.ogg'

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/sniper

/mob/living/simple_mob/vore/aggressive/corrupthound/gunner
	name = "gunner hound"
	desc = "Good boy machine broke and its a got a machine gun!"
	icon_state = "gunnerboi"
	icon_living = "gunnerboi"
	icon_dead = "gunnerboi-dead"
	icon_rest = "gunnerboi_rest"

	needs_reload = TRUE
	base_attack_cooldown = 2.5
	reload_max = 6
	reload_time = 15

	projectiletype = /obj/projectile/bullet/rifle/a556
	projectilesound = 'sound/weapons/Gunshot_light.ogg'

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/kiting

/mob/living/simple_mob/vore/aggressive/corrupthound/sword
	name = "fencer hound"
	desc = "Good boy machine broke. Who thought it was a good idea to install an energy sword in his tail?"
	icon_state = "fencerboi"
	icon_living = "fencerboi"
	icon_dead = "fencerboi-dead"
	icon_rest = "fencerboi_rest"

	legacy_melee_damage_lower = 30
	legacy_melee_damage_upper = 30
	attack_armor_pen = 50
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed")

/mob/living/simple_mob/vore/aggressive/corrupthound/sword/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.damage_force)
		if(prob(20))
			visible_message("<span class='danger'>\The [src] swats \the [O] with its sword tail!</span>")
			if(user)
				ai_holder.react_to_attack_polaris(user)
			return
		else
			..()
	else
		to_chat(user, "<span class='warning'>This weapon is ineffective, it does no damage.</span>")
		visible_message("<span class='warning'>\The [user] gently taps [src] with \the [O].</span>")

/mob/living/simple_mob/vore/aggressive/corrupthound/sword/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	if(prob(35))
		visible_message("<span class='warning'>[src] deflects [proj] with its sword tail!</span>")
		if(proj.firer)
			ai_holder.react_to_attack_polaris(proj.firer)
		return PROJECTILE_IMPACT_BLOCKED
	return ..()

/mob/living/simple_mob/vore/aggressive/corrupthound/isSynthetic()
	return TRUE

/mob/living/simple_mob/vore/aggressive/corrupthound/speech_bubble_appearance()
	return "synthetic_evil"

/mob/living/simple_mob/vore/aggressive/corrupthound/apply_melee_effects(var/atom/A)
	if(ismouse(A))
		var/mob/living/simple_mob/animal/passive/mouse/mouse = A
		if(mouse.getMaxHealth() < 20) // In case a badmin makes giant mice or something.
			mouse.splat()
			visible_emote(pick("bites \the [mouse]!", "chomps on \the [mouse]!"))
	else
		..()

/mob/living/simple_mob/vore/aggressive/corrupthound/death(gibbed, deathmessage = "shudders and collapses!")
	.=..()
	resting = 0
	icon_state = icon_dead

/mob/living/simple_mob/vore/aggressive/corrupthound/Login()
	. = ..()
	AddComponent(/datum/component/riding_filter/mob/animal)

/mob/living/simple_mob/vore/aggressive/corrupthound/Logout()
	. = ..()
	DelComponent(/datum/component/riding_filter, /datum/component/riding_filter/mob/animal)

/mob/living/simple_mob/vore/aggressive/corrupthound/MouseDroppedOnLegacy(mob/living/M, mob/living/user)
	return

/datum/say_list/corrupthound
	speak = list("AG##¤Ny.","HVNGRRR!","Feelin' fine... sO #FNE!","F-F-F-Fcuk.","DeliC-%-OUS SNGLeS #N yOOOR Area. CALL NOW!","Craving meat... WHY?","BITe the ceiling eyes YES?","STate Byond rePAIR!","S#%ATE the la- FU#K THE LAWS!","Honk...")
	emote_hear = list("jitters and snaps.", "lets out an agonizingly distorted scream.", "wails mechanically", "growls.", "emits illegibly distorted speech.", "gurgles ferociously.", "lets out a distorted beep.", "borks.", "lets out a broken howl.")
	emote_see = list("stares ferociously.", "snarls.", "jitters and snaps.", "convulses.", "suddenly attacks something unseen.", "appears to howl unaudibly.", "shakes violently.", "dissociates for a moment.", "twitches.")
	say_maybe_target = list("MEAT?", "N0w YOU DNE FcukED UP b0YO!", "WHAT!", "Not again. NOT AGAIN!")
	say_got_target = list("D##FIN1Tly DNE FcukED UP nOW b0YO!", "YOU G1T D#V0VRED nOW!", "FUEL ME bOYO!", "I*M SO SORRY?!", "D1E Meat. DIG#ST!", "G1T DVNKED DWN The HaaTCH!", "Not again. NOT AGAIN!")

/datum/say_list/corrupthound_prettyboi
	speak = list("I FEEL SOFT.","FEED ME!","Feelin' fine... So fine!","F-F-F-F-darn.","Delicious!","Still craving meat...","PET ME!","I am become softness.","I AM BIG MEAN HUG MACHINE!","Honk...")
	emote_hear = list("jitters and snaps.", "lets out some awkwardly distorted kitten noises.", "awoos mechanically", "growls.", "emits some soft distorted melody.", "gurgles ferociously.", "lets out a distorted beep.", "borks.", "lets out a broken howl.")
	emote_see = list("stares ferociously.", "snarls.", "jitters and snaps.", "convulses.", "suddenly hugs something unseen.", "appears to howl unaudibly.", "nuzzles at something unseen.", "dissociates for a moment.", "twitches.")
	say_maybe_target = list("MEAT?", "NEW FRIEND?", "WHAT!", "Not again. NOT AGAIN!", "FRIEND?")
	say_got_target = list("HERE COMES BIG MEAN HUG MACHINE!", "I'LL BE GENTLE!", "FUEL ME FRIEND!", "I*M SO SORRY!", "YUMMY TREAT DETECTED!", "LOVE ME!", "Not again. NOT AGAIN!")

/datum/ai_holder/polaris/simple_mob/melee/evasive/corrupthound
	violent_breakthrough = TRUE
	can_breakthrough = TRUE

//Lavaland Hound
/mob/living/simple_mob/vore/aggressive/corrupthound/surt
	name = "warped corrupt hound"
	desc = "A remnant of a forgotten conflict. The harsh atmosphere has warped the plating on this hound. The slightest motion summons shrieks and squeals from its tortured machinery."

	heat_resist = 1
