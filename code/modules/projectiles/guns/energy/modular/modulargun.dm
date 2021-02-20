//modular weapons 2. shitcode ahead, be warned.
//i'd just like to say nitsah is annoying as FUCK but also sometimes nice

/obj/item/gun/energy/modular
	name = "the very concept of a modular weapon"
	desc = "An idea, given physical form? Contact your God, the Maker has made a mistake."
	icon_state = "mod_pistol"
	cell_type = /obj/item/cell/device/weapon
	charge_cost = 120
	projectile_type = /obj/item/projectile/beam
	var/cores = 1//How many lasing cores can we support?
	var/assembled = 1 //Are we open?
	var/obj/item/modularlaser/lasermedium/primarycore //Lasing medium core. dictates how much heat is generated and what beam we fire.
	var/obj/item/modularlaser/lasermedium/secondarycore //Lasing medium core.
	var/obj/item/modularlaser/lasermedium/tertiarycore //Lasing medium core.
	var/obj/item/modularlaser/lens/laserlens //Lens. Dictates accuracy. Certain lenses change the projectiles to ENERGY SHOTGUN.
	var/obj/item/modularlaser/capacitor/lasercap
	var/obj/item/modularlaser/cooling/lasercooler
	var/obj/item/modularlaser/controller/circuit
	firemodes = list()
	var/emp_vuln = TRUE
	var/heatmax = 100 //increased by cooling modules, gun frame affects base value. The threshold at which the gun will shut down completely until it cools off, doing damage to the user and potentially forcing the user to drop the gun.
	var/heat //how hot are we?
	var/heat_gen = 10 //how much heat do we generate on firing?
	var/heat_dissipation = 2 //how much heat do we dissipate per decisecond

//
/obj/item/gun/energy/modular/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()
/obj/item/gun/energy/modular/Initialize()
	..()
	generatefiremodes()

/obj/item/gun/energy/modular/examine(mob/user)
	. = ..()
	if(primarycore)
		. += "The modular weapon has a [primarycore.name] installed in the primary core slot."
	if(secondarycore)
		. += "The modular weapon has a [secondarycore.name] installed in the secondary core slot."
	if(tertiarycore)
		. += "The modular weapon has a [tertiarycore.name] installed in the tertiary core slot."
	if(laserlens)
		. += "The modular weapon has a [laserlens.name] installed in the lens slot."
	if(lasercap)
		. += "The modular weapon has a [lasercap.name] installed in the power handler slot."
	if(lasercooler)
		. += "The modular weapon has a [lasercooler.name] installed in the cooling system slot."
	if(circuit)
		. += "The modular weapon has a [circuit.name] installed in the fire control slot."
	if(heat)
		. += "<span class = 'danger'>The [src]'s heat capacity display reads [round((heat/heatmax)*100)]%.</span>"

/obj/item/gun/energy/modular/proc/generatefiremodes() //Accepts no args. Checks the gun's current components and generates projectile types, firemode costs and max burst. Should be called after changing parts or part values.
	if(!circuit)
		return FALSE
	if(!primarycore)
		return FALSE
	if(!laserlens)
		return FALSE
	if(!lasercooler)
		return FALSE
	if(!lasercap)
		return FALSE
	firemodes = list()
	heatmax = initial(heatmax) * lasercooler.heatcapmult
	heat_dissipation = initial(heat_dissipation) * lasercooler.heatremovemod
	var/burstmode = circuit.maxburst //Max burst controlled by the laser control circuit.
	//to_chat(world, "The modular weapon at [src.loc] has begun generating a firemode.")
	var/obj/item/projectile/beammode = primarycore.beamtype //Primary mode fire type.
	var/chargecost = primarycore.beamcost * lasercap.costmod //Cost for primary fire.
	chargecost += lasercooler.costadd //Cooler adds a flat amount post capacitor based on firedelay mod. Can be negative.
	var/scatter = laserlens.scatter //Does it scatter the beams?
	fire_delay = lasercap.firedelay//Firedelay caculated by the capacitor.
	burst_delay = circuit.burst_delay_mult * fire_delay //Ditto, but take the circuit's burst delay mult into account.
	accuracy = laserlens.accuracy
	var/chargecost_lethal = 120
	var/chargecost_special = 120
	var/obj/item/projectile/beammode_lethal
	var/obj/item/projectile/beammode_special
	if(cores > 1 && secondarycore) //Secondary firemode
		beammode_lethal = secondarycore.beamtype
		chargecost_lethal = secondarycore.beamcost * lasercap.costmod
		chargecost_lethal += lasercooler.costadd
	if(cores == 3 && tertiarycore) //Tertiary firemodes
		beammode_special = tertiarycore.beamtype
		chargecost_special = tertiarycore.beamcost * lasercap.costmod
		chargecost_special += lasercooler.costadd
	var/maxburst = circuit.maxburst //Max burst.
	emp_vuln = circuit.robust //is the circuit strong enough to dissipate EMPs?
	//to_chat(world, "The modular weapon at [src.loc] has a max burst of [burstmode], a primary beam type of [beammode], a chargecost of [chargecost], a scatter of [scatter], a firedelay of [fire_delay], a burstdelay of [burst_delay], an accuracy of [accuracy], a chargecost of core 2 [chargecost_lethal], a beamtype of core 2 [beammode_lethal], a chargecost of core 3 [chargecost_special], a beamtype of core 3 [beammode_special]")
	if(primarycore && !secondarycore && !tertiarycore) //this makes me sick but ill ask if there's a better way to do this
		if(chargecost < 0)
			chargecost = 1
		if(scatter)
			beammode = primarycore.scatterbeam
			chargecost *= 2
		if(burstmode > 1)
			firemodes = list(
				new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost, burst = 1, heat_gen = primarycore.heatgen)),
				new /datum/firemode(src, list(mode_name="[maxburst] shot [primarycore.firename]", projectile_type=beammode, charge_cost = chargecost, burst = maxburst, primarycore.heatgen))
				)
			return TRUE
		else
			firemodes = list(
				new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost, burst = 1, primarycore.heatgen))
				)
			return TRUE
	if(primarycore && secondarycore && !tertiarycore)
		if(chargecost < 0)
			chargecost = 0
		if(chargecost_lethal < 0)
			chargecost_lethal = 0
		if(scatter)
			beammode = primarycore.scatterbeam
			beammode_lethal = secondarycore.scatterbeam
			chargecost *= 2
			chargecost_lethal *= 2
		if(burstmode > 1)
			firemodes = list(
				new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost, burst = 1, primarycore.heatgen)),
				new /datum/firemode(src, list(mode_name=secondarycore.firename, projectile_type=beammode_lethal, charge_cost = chargecost_lethal, burst = 1, primarycore.heatgen)),
				new /datum/firemode(src, list(mode_name="[maxburst] shot [primarycore.firename]", projectile_type=beammode, charge_cost = chargecost, burst = maxburst, secondarycore.heatgen)),
				new /datum/firemode(src, list(mode_name="[maxburst] shot [secondarycore.firename]", projectile_type=beammode_lethal, charge_cost = chargecost_lethal, burst = maxburst, secondarycore.heatgen))
				)
			return TRUE
		else
			firemodes = list(
				new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost, burst = 1, primarycore.heatgen)),
				new /datum/firemode(src, list(mode_name=secondarycore.firename, projectile_type=beammode_lethal, charge_cost = chargecost_lethal, burst = 1, secondarycore.heatgen))
			)
			return TRUE
	if(primarycore && secondarycore && tertiarycore)
		if(chargecost < 0)
			chargecost = 1
		if(chargecost_lethal < 0)
			chargecost_lethal = 1
		if(chargecost_special < 0)
			chargecost_special = 1
		if(scatter)
			beammode = primarycore.scatterbeam
			beammode_lethal = secondarycore.scatterbeam
			beammode_special = tertiarycore.scatterbeam
			chargecost *= 2
			chargecost_lethal *= 2
			chargecost_special *= 2
		if(burstmode > 1)
			firemodes = list(
				new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost, burst = 1, primarycore.heatgen)),
				new /datum/firemode(src, list(mode_name=secondarycore.firename, projectile_type=beammode_lethal, charge_cost = chargecost_lethal, burst = 1, secondarycore.heatgen)),
				new /datum/firemode(src, list(mode_name=tertiarycore.firename, projectile_type=beammode_special, charge_cost = chargecost_special, burst = 1, tertiarycore.heatgen)),
				new /datum/firemode(src, list(mode_name="[maxburst] shot [primarycore.firename]", projectile_type=beammode, charge_cost = chargecost, burst = maxburst, primarycore.heatgen)),
				new /datum/firemode(src, list(mode_name="[maxburst] shot [secondarycore.firename]", projectile_type=beammode_lethal, charge_cost = chargecost_lethal, burst = maxburst, secondarycore.heatgen)),
				new /datum/firemode(src, list(mode_name="[maxburst] shot [tertiarycore.firename]", projectile_type=beammode_special, charge_cost = chargecost_special, burst = maxburst, tertiarycore.heatgen))
				)
			return TRUE
		else
			firemodes = list(
				new /datum/firemode(src, list(mode_name=primarycore.firename, projectile_type=beammode, charge_cost = chargecost, burst = 1, primarycore.heatgen)),
				new /datum/firemode(src, list(mode_name=secondarycore.firename, projectile_type=beammode_lethal, charge_cost = chargecost_lethal, burst = 1, secondarycore.heatgen)),
				new /datum/firemode(src, list(mode_name=tertiarycore.firename, projectile_type=beammode_special, charge_cost = chargecost_special, burst = 1, tertiarycore.heatgen))
			)
	else
		return FALSE

/obj/item/gun/energy/modular/emp_act(severity)
	if(!emp_vuln)
		return FALSE
	return ..()

/obj/item/gun/energy/modular/AltClick(mob/user)
	generatefiremodes()
	var/datum/firemode/new_mode = firemodes[1]
	new_mode.apply_to(src)
	to_chat(user, "You hit the reset on the weapon's internal checking system.")


/obj/item/gun/energy/modular/special_check(mob/user)
	. = ..()
	if(!circuit)
		to_chat(user, "<span class='warning'>The gun is missing parts!</span>")
		return FALSE
	if(!primarycore)
		to_chat(user, "<span class='warning'>The gun is missing parts!</span>")
		return FALSE
	if(!laserlens)
		to_chat(user, "<span class='warning'>The gun is missing parts!</span>")
		return FALSE
	if(!lasercooler)
		to_chat(user, "<span class='warning'>The gun is missing parts!</span>")
		return FALSE
	if(!lasercap)
		to_chat(user, "<span class='warning'>The gun is missing parts!</span>")
		return FALSE
	if(!assembled)
		to_chat(user, "<span class='warning'>The gun is open!</span>")
		return FALSE
	if(projectile_type == /obj/item/projectile)
		to_chat(user, "<span class='warning'>The gun is experiencing a checking error! Open and close the weapon, or try removing all the parts and placing them back in.</span>")
		var/datum/firemode/new_mode = firemodes[1]
		new_mode.apply_to(src)
		return FALSE

/obj/item/gun/energy/modular/attackby(obj/item/O, mob/user)
	if(O.is_screwdriver())
		to_chat(user, "<span class='notice'>You [assembled ? "disassemble" : "assemble"] the gun.</span>")
		assembled = !assembled
		playsound(src, O.usesound, 50, 1)
		generatefiremodes()
		return
	if(O.is_crowbar())
		if(assembled == TRUE)
			to_chat(user, "<span class='warning'>Open the [src] first!</span>")
			return
		var/turf/T = get_turf(src)
		if(primarycore && primarycore.removable == TRUE)
			primarycore.forceMove(T)
			primarycore = null
		if(secondarycore && secondarycore.removable == TRUE)
			secondarycore.forceMove(T)
			secondarycore = null
		if(tertiarycore && tertiarycore.removable == TRUE)
			tertiarycore.forceMove(T)
			tertiarycore = null
		if(laserlens && laserlens.removable == TRUE)
			laserlens.forceMove(T)
			laserlens = null
		if(lasercap && lasercap.removable == TRUE)
			lasercap.forceMove(T)
			lasercap = null
		if(lasercooler && lasercooler.removable == TRUE)
			lasercooler.forceMove(T)
			lasercooler = null
		if(circuit && circuit.removable == TRUE)
			circuit.forceMove(T)
			circuit = null
		generatefiremodes()
	if(istype(O, /obj/item/modularlaser))
		if(assembled == TRUE)
			to_chat(user, "<span class='warning'>Open the [src] first!</span>")
			return
		var/obj/item/modularlaser/ML = O
		if(istype(ML,/obj/item/modularlaser/lasermedium))
			var/obj/item/modularlaser/lasermedium/med = ML
			if(!primarycore && cores >= 1)
				primarycore = med
				user.drop_item()
				med.forceMove(src)
				to_chat(user, "<span class='notice'>You install the [med.name] in the primary core slot.</span>")
				generatefiremodes()
				return
			if(!secondarycore && cores >= 2)
				secondarycore = med
				user.drop_item()
				med.forceMove(src)
				to_chat(user, "<span class='notice'>You install the [med.name] in the secondary core slot.</span>")
				generatefiremodes()
				return
			if(!tertiarycore && cores == 3)
				tertiarycore = med
				user.drop_item()
				med.forceMove(src)
				to_chat(user, "<span class='notice'>You install the [med.name] in the tertiary core slot.</span>")
				generatefiremodes()
				return
		if(istype(ML, /obj/item/modularlaser/lens))
			var/obj/item/modularlaser/lens/L = ML
			if(!laserlens)
				laserlens = L
				user.drop_item()
				L.forceMove(src)
				to_chat(user, "<span class='notice'>You install the [L.name] in the lens holder.</span>")
				generatefiremodes()
				return
		if(istype(ML, /obj/item/modularlaser/capacitor))
			var/obj/item/modularlaser/capacitor/C = ML
			if(!lasercap)
				lasercap = C
				user.drop_item()
				C.forceMove(src)
				to_chat(user, "<span class='notice'>You install the [C.name] in the power supply slot.</span>")
				generatefiremodes()
				return
		if(istype(ML, /obj/item/modularlaser/cooling))
			var/obj/item/modularlaser/cooling/CO = ML
			if(!lasercooler)
				lasercooler = CO
				user.drop_item()
				CO.forceMove(src)
				to_chat(user, "<span class='notice'>You install the [CO.name] in the cooling system mount.</span>")
				generatefiremodes()
				return
		if(istype(ML, /obj/item/modularlaser/controller))
			var/obj/item/modularlaser/controller/CON = ML
			if(!circuit)
				circuit = CON
				user.drop_item()
				CON.forceMove(src)
				to_chat(user, "<span class='notice'>You install the [CON.name] in the fire control unit mount and connect it.</span>")
				generatefiremodes()
				return
	generatefiremodes()
	..()

/obj/item/gun/energy/modular/Fire(mob/living/user)
	..()
	handle_heat(user)


/obj/item/gun/energy/modular/proc/handle_heat(mob/living/user) //handle heat, processing if we have heat, burning the user if we're too hot
	heat += heat_gen
	if(heat)
		START_PROCESSING(SSobj, src)
	var/mob/living/carbon/human/H
	var/hand_to_burn
	if(ishuman(user))
		H = user
		hand_to_burn = (src == H.l_hand) ? BP_L_HAND : BP_R_HAND
	switch(heat/heatmax * 100)
		if(45 to 64)
			to_chat(user, "<span class = 'danger'> The [src] grows warm in your hands!</span>")
			return
		if(85 to 94)
			to_chat(user, "<span class = 'danger'> The [src] singes you lightly!</span>")
			if(H)
				H.apply_damage(1, BURN, hand_to_burn)
			return
		if(95 to 99)
			to_chat(user, "<span class = 'danger'> The [src] burns you, it's close to overheating!</span>")
			if(H)
				H.apply_damage(3, BURN, hand_to_burn)
			return
		if(100 to INFINITY)
			to_chat(user, "<span class = 'danger'> The emergency heat vent on [src] activates, burning your hand!</span>")
			if(H)
				H.apply_damage(15, BURN, hand_to_burn)
				H.drop_item()
			return


/obj/item/gun/energy/modular/process(delta_time)
	if(heat)
		heat = max(0, heat - heat_dissipation)
		return
	else
		STOP_PROCESSING(SSobj, src)

//these are debug ones.
/obj/item/gun/energy/modular/twocore
	name = "bicore modular weapon"
	cores = 2

/obj/item/gun/energy/modular/threecore
	name = "tricore modular weapon"
	cores = 3



//parts
/obj/item/modularlaser
	name = "modular laser part"
	desc = "I shouldn't exist."
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "modkit"
	var/removable = TRUE
