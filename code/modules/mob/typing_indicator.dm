/mob/proc/init_typing_indicator(indicator)
	if(!indicator)
		indicator = "[speech_bubble_appearance()]_typing"
	if(typing_indicator)
		cut_overlay(typing_indicator, TRUE)
	typing = FALSE
	typing_indicator = mutable_appearance('icons/mob/talk_vr.dmi', indicator, FLOAT_LAYER)
	typing_indicator.appearance_flags |= RESET_COLOR | PIXEL_SCALE

/mob/proc/set_typing_indicator(state)
	if(!state)
		if(!typing)
			return
		cut_overlay(typing_indicator, TRUE)
		typing = FALSE
	else
		if(typing)
			return
		if(!typing_indicator)
			init_typing_indicator()
		add_overlay(typing_indicator, TRUE)
		typing = TRUE

/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = 1

	set_typing_indicator(TRUE)
	var/message = input("","say (text)") as text|null
	set_typing_indicator(FALSE)

	if(message)
		say_verb(message)

/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = 1

	set_typing_indicator(TRUE)
	var/message = input("","me (text)") as message|null
	set_typing_indicator(FALSE)

	if(message)
		me_verb(message)
