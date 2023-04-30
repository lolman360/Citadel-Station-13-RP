/obj/item/clothing/accessory/storage
	name = "load bearing equipment"
	desc = "Used to hold things when you don't have enough hands."
	icon_state = "webbing"
	slot = ACCESSORY_SLOT_UTILITY
	show_messages = 1

	var/slots = 5
	var/obj/item/storage/internal/hold
	w_class = ITEMSIZE_NORMAL
	on_rolled = list("down" = "none")
	var/hide_on_roll = FALSE

/obj/item/clothing/accessory/storage/Initialize(mapload)
	. = ..()
	hold = new/obj/item/storage/internal(src)
	hold.max_storage_space = slots * 2
	hold.max_w_class = ITEMSIZE_SMALL
	if (!hide_on_roll)
		on_rolled["down"] = icon_state

/obj/item/clothing/accessory/storage/attack_hand(mob/user, list/params)
	if (accessory_host)	//if we are part of a suit
		hold.open(user)
		return

	if (hold.handle_attack_hand(user))	//otherwise interact as a regular storage item
		..(user)

/obj/item/clothing/accessory/storage/OnMouseDropLegacy(obj/over_object as obj)
	if (accessory_host)
		return

	if (hold.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/accessory/storage/attackby(obj/item/W as obj, mob/user as mob)
	return hold.attackby(W, user)

/obj/item/clothing/accessory/storage/emp_act(severity)
	hold.emp_act(severity)
	..()

/obj/item/clothing/accessory/storage/attack_self(mob/user)
	. = ..()
	if(.)
		return
	to_chat(user, "<span class='notice'>You empty [src].</span>")
	var/turf/T = get_turf(src)
	hold.hide_from(usr)
	for(var/obj/item/I in hold.contents)
		hold.remove_from_storage(I, T)
	add_fingerprint(user)

/obj/item/clothing/accessory/storage/webbing
	name = "webbing"
	desc = "Sturdy mess of synthcotton belts and buckles, ready to share your burden."
	icon_state = "webbing"
	slots = 3

/obj/item/clothing/accessory/storage/black_vest
	name = "black webbing vest"
	desc = "Robust black synthcotton vest with lots of pockets to hold whatever you need, but cannot hold in hands."
	icon_state = "vest_black"

/obj/item/clothing/accessory/storage/brown_vest
	name = "brown webbing vest"
	desc = "Worn brownish synthcotton vest with lots of pockets to unload your hands."
	icon_state = "vest_brown"

/obj/item/clothing/accessory/storage/white_vest
	name = "white webbing vest"
	desc = "Durable white synthcotton vest with lots of pockets to carry essentials."
	icon_state = "vest_white"

/obj/item/clothing/accessory/storage/black_drop_pouches
	name = "black drop pouches"
	gender = PLURAL
	desc = "Robust black synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon_state = "thigh_black"

/obj/item/clothing/accessory/storage/brown_drop_pouches
	name = "brown drop pouches"
	gender = PLURAL
	desc = "Worn brownish synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon_state = "thigh_brown"

/obj/item/clothing/accessory/storage/white_drop_pouches
	name = "white drop pouches"
	gender = PLURAL
	desc = "Durable white synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon_state = "thigh_white"

/obj/item/clothing/accessory/storage/knifeharness
	name = "decorated harness"
	desc = "A heavily decorated harness of sinew and leather with two knife-loops."
	icon_state = "unathiharness2"
	slots = 2

/obj/item/clothing/accessory/storage/voyager
	name = "voyager harness"
	desc = "A leather harness adorned with soft and hard-case pouches, designed for expeditions."
	icon_state = "explorer"

//Pilot
/obj/item/clothing/accessory/storage/webbing/pilot1
	name = "pilot harness"
	desc = "Sturdy mess of black synthcotton belts and buckles."
	icon_state = "pilot_webbing1"

/obj/item/clothing/accessory/storage/webbing/pilot2
	name = "pilot harness"
	desc = "Sturdy mess of black synthcotton belts and buckles."
	icon_state = "pilot_webbing2"
	sprite_sheets = list(
			BODYTYPE_STRING_TESHARI = 'icons/mob/clothing/species/teshari/ties.dmi'
			)

/obj/item/clothing/accessory/storage/knifeharness/Initialize(mapload)
	. = ..()
	hold.max_storage_space = ITEMSIZE_COST_SMALL * 2
	hold.can_hold = list(/obj/item/material/knife/machete/hatchet/unathiknife,\
	/obj/item/material/knife,\
	/obj/item/material/knife/plastic)

	new /obj/item/material/knife/machete/hatchet/unathiknife(hold)
	new /obj/item/material/knife/machete/hatchet/unathiknife(hold)

/obj/item/clothing/accessory/storage/laconic
	name = "laconic field pouch system"
	desc = "This lightweight webbing system supports a hardened leather case designed to sit comfortably on the wearer's hip."
	icon_state = "laconic"
	slot = ACCESSORY_SLOT_UTILITY
	slots = 5
