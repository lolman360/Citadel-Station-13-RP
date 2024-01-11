/mob/living/proc/spam_flag_false() //used for addtimer
	spam_flag = FALSE


/mob/living/emote(var/act,var/m_type=1,var/message = null)
	var/param = null
	var/datum/gender/T = GLOB.gender_datums[get_visible_gender()]
	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	//if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
	//	act = copytext(act,1,length(act))

	var/muzzled = is_muzzled()
	//var/m_type = 1

	for(var/obj/item/organ/O in src.organs)
		for (var/obj/item/implant/I in O)
			if (I.implanted)
				I.trigger(act, src)

	if(src.stat == 2.0 && (act != "deathgasp"))
		return
	if(attempt_vr(src,"handle_emote_vr",list(act,m_type,message)))
		return // Custom Emote Handler
	switch(act)


		if ("airguitar")
			if (!src.restrained())
				message = "is strumming the air and headbanging like a safari chimp."
				m_type = 1

		//Machine-only emotes
		if("beep", "buzz", "buzz2", "chime", "die", "dwoop", "error", "honk", "no", "ping", "rcough", "rsneeze", "scary", "shutdown","startup", "warn", "ye", "yes")

			var/obj/item/organ/o = internal_organs_by_name[O_VOICE]
			if(!isSynthetic() && (!o || !(o.robotic >= ORGAN_ASSISTED)))
				to_chat(src, "<span class='warning'>You are not a synthetic.</span>")
				return

			var/M = null
			if(param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if(!M)
				param = null

			var/display_msg = "beeps"
			var/use_sound = 'sound/machines/twobeep.ogg'
			if(act == "buzz")
				display_msg = "buzzes"
				use_sound = 'sound/machines/buzz-sigh.ogg'
			else if(act == "chime")
				display_msg = "chimes"
				use_sound = 'sound/machines/chime.ogg'
			else if(act == "buzz2")
				display_msg = "buzzes twice"
				use_sound = 'sound/machines/buzz-two.ogg'
			else if(act == "warn")
				display_msg = "blares an alarm"
				use_sound = 'sound/machines/warning-buzzer.ogg'
			else if(act == "honk")
				display_msg = "honks"
				use_sound = 'sound/items/bikehorn.ogg'
			else if(act == "ping")
				display_msg = "pings"
				use_sound = 'sound/machines/ping.ogg'
			else if(act == "yes" || act == "ye")
				display_msg = "emits an affirmative blip"
				use_sound = 'sound/machines/synth_yes.ogg'
			else if(act == "no")
				display_msg = "emits a negative blip"
				use_sound = 'sound/machines/synth_no.ogg'
			else if(act == "dwoop")
				display_msg = "chirps happily"
				use_sound = 'sound/machines/dwoop.ogg'
			else if(act == "scary")
				display_msg = "emits a disconcerting tone"
				use_sound = 'sound/machines/synth_scary.ogg'
			else if(act == "startup")
				display_msg = "chimes to life"
				use_sound = 'sound/machines/synth_startup.ogg'
			else if(act == "shutdown")
				display_msg = "emits a nostalgic tone as they fall silent"
				use_sound = 'sound/machines/synth_shutdown.ogg'
			else if(act == "error")
				display_msg = "experiences a system error"
				use_sound = 'sound/machines/synth_error.ogg'
			else if(act == "die")
				display_msg = "crumples, their chassis colder and more lifeless than usual"
				use_sound = 'sound/machines/synth_gameover.ogg'
			else if(act == "rcough")
				display_msg = "emits a robotic cough"
				if(get_gender() == FEMALE)
					use_sound = pick('sound/effects/mob_effects/f_machine_cougha.ogg','sound/effects/mob_effects/f_machine_coughb.ogg')
				else
					use_sound = pick('sound/effects/mob_effects/m_machine_cougha.ogg','sound/effects/mob_effects/m_machine_coughb.ogg', 'sound/effects/mob_effects/m_machine_coughc.ogg')
			else if(act == "rsneeze")
				display_msg = "emits a robotic sneeze"
				if(get_gender() == FEMALE)
					use_sound = 'sound/effects/mob_effects/machine_sneeze.ogg'
				else
					use_sound = 'sound/effects/mob_effects/f_machine_sneeze.ogg'

			if (param)
				message = "[display_msg] at [param]."
			else
				message = "[display_msg]."
			playsound(src.loc, use_sound, 50, 0)
			m_type = 1

		if("kiss")
			var/next_to_target = FALSE
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						if(src.Adjacent(A))
							next_to_target = TRUE
						break
				if (!M)
					param = null

				if (param)
					var/distance_verb = next_to_target ? "kisses" : "blows a kiss at"
					message = "[distance_verb] [param]."
			else
				message = "makes a kissing mouth."
			m_type = 1

		if("smooch")
			if (param)
				var/M = null
				for (var/mob/A in view(1,src.loc))
					if (param == A.name)
						M = A
						break
				if (!M)
					param = null

				if (param)
					message = "smooches [param]."
			m_type = 1

		if ("blink")
			message = "blinks."
			m_type = 1

		if ("blink_r")
			message = "blinks rapidly."
			m_type = 1

		if ("bow")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "bows to [param]."
				else
					message = "bows."
			m_type = 1

		if ("custom")
			var/input = sanitize(input("Choose an emote to display.") as text|null)
			if (!input)
				return
			var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
			if (input2 == "Visible")
				m_type = 1
			else if (input2 == "Hearable")
				if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
					return
				m_type = 2
			else
				alert("Unable to use this emote, must be either hearable or visible.")
				return
			return custom_emote(m_type, message)

		if ("me")

			//if(silent && silent > 0 && findtext(message,"\"",1, null) > 0)
			//	return //This check does not work and I have no idea why, I'm leaving it in for reference.

			if (src.client)
				if (client.prefs.muted & MUTE_IC)
					to_chat(src, "<font color='red'>You cannot send IC messages (muted).</font>")
					return
			if (stat)
				return
			if(!(message))
				return
			return custom_emote(m_type, message)

		if ("salute")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "salutes to [param]."
				else
					message = "salutes."
			m_type = 1

		if ("fullsalute")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(null, null))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null

				if (param)
					message = "salutes to [param]."
				else
					message = "salutes."

				playsound(src.loc, 'sound/misc/salute.ogg', 30, 0)
			m_type = 1


		if ("choke")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "clutches [T.his] throat desperately!"
				m_type = 1
			else
				if (!muzzled)
					message = "chokes!"
					m_type = 2
				else
					message = "makes a strong noise."
					m_type = 2

		if ("clap")
			if (!src.restrained())
				message = "claps."
				var/use_sound
				use_sound = pick('sound/misc/clapping.ogg','sound/voice/clap2.ogg','sound/voice/clap3.ogg','sound/voice/clap4.ogg')
				playsound(src.loc, use_sound, 50, 0)

		if("golfclap")
			if (!src.restrained())
				message = "claps very slowly."
				playsound(src.loc, 'sound/voice/golfclap.ogg', 50, 0)

		if ("flap")
			if (!src.restrained())
				message = "flaps [T.his] wings."
				m_type = 2
				if(HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT))
					m_type = 1

		if ("aflap")
			if (!src.restrained())
				message = "flaps [T.his] wings ANGRILY!"
				m_type = 2
				if(HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT))
					m_type = 1

		if("ara")
			message = "aras."
			var/use_sound
			use_sound = pick('sound/voice/ara_ara1.ogg','sound/voice/ara_ara2.ogg')
			playsound(src.loc, use_sound, 50, 0)

		if("uwu")
			message = "lets out a devious noise."
			playsound(src.loc, 'sound/voice/uwu.ogg', 50, 0)

		if ("drool")
			message = "drools."
			m_type = 1

		if ("eyebrow")
			message = "raises an eyebrow."
			m_type = 1

		if ("chuckle")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "appears to chuckle."
				m_type = 1
			else
				if (!muzzled)
					message = "chuckles."
					m_type = 2
				else
					message = "makes a noise."
					m_type = 2

		if ("twitch")
			message = "twitches."
			m_type = 1

		if ("twitch_v")
			message = "twitches violently."
			m_type = 1

		if ("faint")
			message = "faints."
			if(!IS_CONSCIOUS(src))
				return //Can't faint while asleep
			afflict_sleeping(20 * 10) //Short-short nap
			m_type = 1

		if("flip")
			if(!CHECK_ALL_MOBILITY(src, MOBILITY_CAN_MOVE | MOBILITY_CAN_USE))
				to_chat(src, "<span class='warning'>You can't *flip in your current state!</span>")
			else
				src.SpinAnimation(7,1)
				m_type = 1

		if("cough", "coughs")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "appears to cough!"
				m_type = 1
			else
				if(!muzzled)
					m_type = 2
					var/obj/item/organ/o = internal_organs_by_name[O_VOICE]
					if(!isSynthetic() && (!o || !(o.robotic >= ORGAN_ASSISTED)))
						message = "coughs!"
						if(get_gender() == FEMALE)
							playsound(src, pick('sound/effects/mob_effects/f_cougha.ogg','sound/effects/mob_effects/f_coughb.ogg'), 120)
						else
							playsound(src, pick('sound/effects/mob_effects/m_cougha.ogg','sound/effects/mob_effects/m_coughb.ogg', 'sound/effects/mob_effects/m_coughc.ogg'), 120)
					else
						message = "emits a robotic cough"
						var/use_sound
						if(get_gender() == FEMALE)
							use_sound = pick('sound/effects/mob_effects/f_machine_cougha.ogg','sound/effects/mob_effects/f_machine_coughb.ogg')
						else
							use_sound = pick('sound/effects/mob_effects/m_machine_cougha.ogg','sound/effects/mob_effects/m_machine_coughb.ogg', 'sound/effects/mob_effects/m_machine_coughc.ogg')
						playsound(src.loc, use_sound, 50, 0)
				else
					message = "makes a strong noise."
					m_type = 2

		if("bcough")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "appears to cough up blood!"
				m_type = 1
			else
				if(!muzzled)
					m_type = 2
					var/obj/item/organ/o = internal_organs_by_name[O_VOICE]
					if(!isSynthetic() && (!o || !(o.robotic >= ORGAN_ASSISTED)))
						message = "coughs up a small amount of blood!"
						if(get_gender() == FEMALE)
							playsound(src, pick('sound/effects/mob_effects/f_cougha.ogg','sound/effects/mob_effects/f_coughb.ogg'), 120)
						else
							playsound(src, pick('sound/effects/mob_effects/m_cougha.ogg','sound/effects/mob_effects/m_coughb.ogg', 'sound/effects/mob_effects/m_coughc.ogg'), 120)

		if ("frown")
			message = "frowns."
			m_type = 1

		if ("nod")
			message = "nods."
			m_type = 1

		if ("blush")
			message = "blushes."
			m_type = 1

		if ("wave")
			message = "waves."
			m_type = 1

		if ("gasp")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "appears to be gasping!"
				m_type = 1
			else
				if (!muzzled)
					message = "gasps!"
					m_type = 2
				else
					message = "makes a weak noise."
					m_type = 2

		if ("deathgasp")
			message = "seizes up and falls limp..." //default dm
			m_type = 1

		if ("giggle")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "giggles silently!"
				m_type = 1
			else
				if (!muzzled)
					message = "giggles."
					m_type = 2
				else
					message = "makes a noise."
					m_type = 2

		if ("glare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				message = "glares at [param]."
			else
				message = "glares."

		if ("stare")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if (!M)
				param = null

			if (param)
				message = "stares at [param]."
			else
				message = "stares."

		if ("look")
			var/M = null
			if (param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break

			if (!M)
				param = null

			if (param)
				message = "looks at [param]."
			else
				message = "looks."
			m_type = 1

		if ("grin")
			message = "grins."
			m_type = 1

		if ("cry")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "cries."
				m_type = 1
			else
				if (!muzzled)
					message = "cries."
					m_type = 2
				else
					message = "makes a weak noise. [T.he] [get_visible_gender() == NEUTER ? "frown" : "frowns"]." // no good, non-unwieldy alternative to this ternary at the moment
					m_type = 2

		if ("sigh")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "sighs."
				m_type = 1
			else
				if (!muzzled)
					message = "sighs."
					m_type = 2
				else
					message = "makes a weak noise."
					m_type = 2

		if ("laugh")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "acts out a laugh."
				m_type = 1
			else
				if (!muzzled)
					var/list/laughs = list("lets out a chuckle.", "laughs.", "chuckles.", "cracks up.", "erupts into laughter.", "cackles.")
					message = "[pick(laughs)]"
					if(!spam_flag)
						if(get_gender() == MALE)
							var/list/laughsounds = list('sound/voice/laughs/masclaugh1.ogg', 'sound/voice/laughs/masclaugh2.ogg')
							playsound(loc, pick(laughsounds), 50, 1, -1)
							spam_flag = TRUE
							addtimer(CALLBACK(src, PROC_REF(spam_flag_false)), 18)
						else
							playsound(loc, 'sound/voice/laughs/femlaugh.ogg', 50, 1, -1)
							spam_flag = TRUE
							addtimer(CALLBACK(src, PROC_REF(spam_flag_false)), 18)
					m_type = 2
				else
					message = "makes a noise."
					m_type = 2

		if ("mumble")
			message = "mumbles!"
			m_type = 2
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				m_type = 1

		if ("grumble")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "grumbles!"
				m_type = 1
			if (!muzzled)
				message = "grumbles!"
				m_type = 2
			else
				message = "makes a noise."
				m_type = 2

		if ("groan")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "appears to groan!"
				m_type = 1
			else
				if (!muzzled)
					message = "groans!"
					m_type = 2
				else
					message = "makes a loud noise."
					m_type = 2

		if ("moan")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "appears to moan!"
				m_type = 1
			else
				message = "moans!"
				m_type = 2

		if ("johnny")
			var/M
			if (param)
				M = param
			if (!M)
				param = null
			else
				if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
					message = "takes a drag from a cigarette and blows \"[M]\" out in smoke."
					m_type = 1
				else
					message = "says, \"[M], please. He had a family.\" [src.name] takes a drag from a cigarette and blows his name out in smoke."
					m_type = 2

		if ("point")
			if (!src.restrained())
				var/mob/M = null
				if (param)
					for (var/atom/A as mob|obj|turf|area in view(null, null))
						if (param == A.name)
							M = A
							break

				if (!M)
					message = "points."
				else
					pointed(M)

				if (M)
					message = "points to [M]."
				else
			m_type = 1

		if("crack")
			if(!restrained())
				message = "cracks [T.his] knuckles."
				playsound(src, 'sound/voice/knuckles.ogg', 50, 1,)
				m_type = 1

		if ("raise")
			if (!src.restrained())
				message = "raises a hand."
			m_type = 1

		if("shake")
			message = "shakes [T.his] head."
			m_type = 1

		if ("shrug")
			message = "shrugs."
			m_type = 1

		if ("signal")
			if (!src.restrained())
				var/t1 = round(text2num(param))
				if (isnum(t1))
					if (t1 <= 5 && (!src.r_hand || !src.l_hand))
						message = "raises [t1] finger\s."
					else if (t1 <= 10 && (!src.r_hand && !src.l_hand))
						message = "raises [t1] finger\s."
			m_type = 1

		if ("smile")
			message = "smiles."
			m_type = 1

		if ("shiver")
			message = "shivers."
			m_type = 2
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				m_type = 1

		if ("pale")
			message = "goes pale for a second."
			m_type = 1

		if ("tremble")
			message = "trembles in fear!"
			m_type = 1

		if("sneeze", "sneezes")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "sneezes."
				m_type = 1
			else
				if(!muzzled)
					m_type = 2
					var/obj/item/organ/o = internal_organs_by_name[O_VOICE]
					if(!isSynthetic() && (!o || !(o.robotic >= ORGAN_ASSISTED)))
						message = "sneezes."
						if(get_gender() == FEMALE)
							playsound(src, 'sound/effects/mob_effects/f_sneeze.ogg', 70)
						else
							playsound(src, 'sound/effects/mob_effects/sneeze.ogg', 70)
						m_type = 2
					else
						message = "emits a robotic sneeze"
						var/use_sound
						if(get_gender() == FEMALE)
							use_sound = 'sound/effects/mob_effects/machine_sneeze.ogg'
						else
							use_sound = 'sound/effects/mob_effects/f_machine_sneeze.ogg'
						playsound(src.loc, use_sound, 50, 0)
				else
					message = "makes a strange noise."
					m_type = 2

		if ("sniff")
			message = "sniffs."
			m_type = 2
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				m_type = 1

		if ("snore")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "sleeps soundly."
				m_type = 1
			else
				if (!muzzled)
					message = "snores."
					m_type = 2
				else
					message = "makes a noise."
					m_type = 2

		if ("whimper")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "appears hurt."
				m_type = 1
			else
				if (!muzzled)
					message = "whimpers."
					m_type = 2
				else
					message = "makes a weak noise."
					m_type = 2

		if ("wink")
			message = "winks."
			m_type = 1

		if ("yawn")
			if (!muzzled)
				message = "yawns."
				m_type = 2
				if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
					m_type = 1

		if ("collapse")
			afflict_unconscious(20 * 2)
			message = "collapses!"
			m_type = 2
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				m_type = 1

		if("hug")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					message = "hugs [M]."
				else
					message = "hugs [T.himself]."

		if ("handshake")
			m_type = 1
			if (!src.restrained() && !src.r_hand)
				var/mob/living/M = null
				if (param)
					for (var/mob/living/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null

				if (M)
					if (CHECK_MOBILITY(M, MOBILITY_CAN_USE))
						message = "shakes hands with [M]."
					else
						message = "holds out [T.his] hand to [M]."

		if("dap")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, null))
						if (param == A.name)
							M = A
							break
				if (M)
					message = "gives daps to [M]."
				else
					message = "sadly can't find anybody to give daps to, and daps [T.himself]. Shameful."

		if("slap", "slaps")
			m_type = 1
			if(!restrained())
				var/M = null
				if(param)
					for(var/mob/A in view(1, null))
						if(param == A.name)
							M = A
							break
				if(M)
					message = "<span class='danger'>slaps [M] across the face. Ouch!</span>"
					playsound(src, 'sound/effects/snap.ogg', 50, 1)
					if(ishuman(M)) //Snowflakey!
						var/mob/living/carbon/human/H = M
						if(istype(H.wear_mask,/obj/item/clothing/mask/smokable))
							H.drop_item_to_ground(H.wear_mask)
				else
					message = "<span class='danger'>slaps [T.himself]!</span>"
					playsound(loc, 'sound/effects/snap.ogg', 50, 1)

//Citadel changes starts here
		if ("fguns")
			message = "points some fingerguns."
			m_type = 1

		if("aslap", "aslaps")
			m_type = 1

			if(!CHECK_ALL_MOBILITY(src, MOBILITY_CAN_USE))
				to_chat(usr, "You need at least one hand in good working order to slap someone.")
				return
			if(!restrained())
				var/M = null
				if(param)
					for(var/mob/A in view(1, null))
						if(param == A.name)
							M = A
							break
				if(M)
					message = "<span class='danger'>slaps [M]'s butt.</span>"
					playsound(loc, 'sound/effects/snap.ogg', 50, 1)
					add_attack_logs(src,M,"Buttslap")
				else
					message = "<span class='danger'>slaps [T.his] own butt!</span>"
					playsound(loc, 'sound/effects/snap.ogg', 50, 1)
					add_attack_logs(src,src,"Slapped own butt")
					//adding damage for aslaps to stop the spam

		if("scream", "screams")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "acts out a scream!"
				m_type = 1
			else
				if(!muzzled)
					message = "screams!"
					m_type = 2
					if(get_gender() == FEMALE)
						if(!spam_flag)
							playsound(loc, "[pick('sound/voice/screams/sound_voice_scream_scream_f1.ogg', 'sound/voice/screams/sound_voice_scream_scream_f2.ogg', 'sound/voice/screams/sound_voice_scream_scream_f3.ogg')]", 80, 1)
							spam_flag = TRUE
							addtimer(CALLBACK(src, PROC_REF(spam_flag_false)), 18)

					else
						if(!spam_flag)
							playsound(loc, "[pick('sound/voice/screams/sound_voice_scream_scream_m1.ogg', 'sound/voice/screams/sound_voice_scream_scream_m2.ogg')]", 80, 1) //default to male screams if no gender is present.
							spam_flag = TRUE
							addtimer(CALLBACK(src, PROC_REF(spam_flag_false)), 18)
				else
					message = "makes a very loud noise."
					m_type = 2
		if("squeak","squeaks")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "acts out a soft squeak."
				m_type = 1
			else
				if(!muzzled)
					message = "squeaks!"
					m_type = 2
					playsound(loc, "sound/effects/mouse_squeak.ogg", 50, 1)

		if("meow", "meows")
			if HAS_TRAIT_FROM(src, TRAIT_MUTE, MIME_TRAIT)
				message = "acts out a soft mrowl."
				m_type = 1
			else
				if(!muzzled)
					message = "mrowls!"
					m_type = 2
					playsound(loc, 'sound/voice/meow1.ogg', 50, 1)

		if("snap", "snaps")
			m_type = 2
	
			if(!CHECK_ALL_MOBILITY(src, MOBILITY_CAN_USE))
				to_chat(usr, "You need at least one hand in good working order to snap your fingers.")
				return
			if(!restrained())
				message = "snaps [T.his] fingers."
				playsound(loc, 'sound/effects/fingersnap.ogg', 50, 1, -3)

		if("vomit")
			if(isSynthetic())
				to_chat(src, "<span class='warning'>You are unable to vomit.</span>")
				return
			vomit()
			return

		if("whistle", "whistles")
			if(!muzzled)
				message = "whistles a tune."
				playsound(loc, 'sound/misc/longwhistle.ogg') //praying this doesn't get abused
			else
				message = "makes a light spitting noise, a poor attempt at a whistle."

		if("qwhistle")
			if(!muzzled)
				message = "whistles quietly."
				playsound(loc, 'sound/misc/shortwhistle.ogg')
			else
				message = "makes a light spitting noise, a poor attempt at a whistle."

		if ("roll")
			var/usage = "To use this emote specify what die you want to roll in the first line. Prefix it with a \"D\". You may add a bonus to your roll, simply add a \"+\" and your number after your chosen die. If you want to incorporate a difficulty check, add a \"-DC\". You may use a bonus, a difficulty check or both.<br>Here is an example: roll-D20+5-DC15. This will roll a twenty-sided die, add five and compare it against a difficulty check of 15."
			if(!param)
				to_chat(src, usage)
				return

			var/t1 = findtext(param, "+", 1, null)
			var/t2 = findtext(param, "-", 1, null)
			var/die = copytext(param, 1, t1)
			var/bonus = copytext(param, t1 + 1, t2)
			var/dc = copytext(param, t2 + 1, length(param) + 1 )
			if (!t1)
				bonus = null
			if (!t2)
				dc = null
			var/die_number = text2num(copytext(die, 2, length(die) + 1))
			var/bonus_number = text2num(bonus)
			var/dc_number = text2num(copytext(dc, 3, length(dc) + 1))

			var/die_result = rand(die_number - 1) + 1
			var/die_total = die_result + bonus_number

			if (die_number && bonus_number && dc_number)
				if (die_total >= dc_number)
					message = SPAN_GREEN("tries something. They succeed, beating a difficulty check of [dc_number] with a roll of [die_result] + [bonus_number] for a total of [die_total] out of a possible [die_number + bonus_number]!")
				if (die_total < dc_number)
					message = SPAN_RED("tries something. They fail, losing to a difficulty check of [dc_number] with a roll of [die_result] + [bonus_number] for a total of [die_total] out of a possible [die_number + bonus_number]!")

			else if (die_number && dc_number)
				if (die_result >= dc_number)
					message = SPAN_GREEN("tries something. They succeed, beating a difficulty check of [dc_number] with a roll of [die_total] out of [die_number]!")
				if (die_result < dc_number)
					message = SPAN_RED("tries something. They fail, losing to a difficulty check of [dc_number] with a roll of [die_total] out of [die_number]!")

			else if (die_number && bonus_number)
				message = "tries something. They roll a [die_result] + [bonus_number] for a total of [die_total] out of a possible [die_number + bonus_number]!"

			else if (die_number)
				message = "tries something. They roll a [die_result] out of [die_number]!"

			else if (!message)
				to_chat(src, usage)
				return

		if ("help")
			to_chat(src, "nyaha, awoo, bark, blink, blink_r, blush, bow-(none)/mob, burp, chirp, choke, chuckle, clap, collapse, cough, cry, custom, deathgasp, drool, eyebrow, fastsway/qwag, \
					flip, frown, gasp, giggle, glare-(none)/mob, grin, groan, grumble, handshake, hiss, hug-(none)/mob, laugh, look-(none)/mob, merp, moan, mumble, nod, nya, pale, peep, point-atom, \
					raise, roll, salute, fullsalute, scream, sneeze, shake, shiver, shrug, sigh, signal-#1-10, slap-(none)/mob, smile, sneeze, sniff, snore, stare-(none)/mob, stopsway/swag, squeak, sway/wag, swish, tremble, twitch, \
					twitch_v, vomit, weh, whimper, wink, yawn. Moth: mchitter, mlaugh, mscream, msqueak. Synthetics: beep, buzz, buzz2, chime, die, dwoop, error, honk, no, ping, rcough, rsneeze, scary, \
					shutdown, startup, warn, ye, yes.")

		else
			to_chat(src, "<font color=#4F49AF>Unusable emote '[act]'. Say *help for a list.</font>")
			return

	if (message)
		custom_emote(m_type,message)
