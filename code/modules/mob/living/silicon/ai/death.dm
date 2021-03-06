/mob/living/silicon/ai/death(gibbed)
	if(stat == DEAD)
		return
	if(!gibbed)
		emote("me", 1, "sparks and its screen flickers, its systems slowly coming to a halt.")
	stat = DEAD


	if("[icon_state]_dead" in icon_states(src.icon,1))
		icon_state = "[icon_state]_dead"
	else
		icon_state = "ai_dead"

	anchored = 0 //unbolt floorbolts
	update_canmove()
	if(src.eyeobj)
		src.eyeobj.setLoc(get_turf(src))
	if(blind)	blind.layer = 0
	sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_LEVEL_TWO

	shuttle_caller_list -= src
	SSshuttle.autoEvac()

	if(nuking)
		set_security_level("red")
		nuking = 0
		SSshuttle.emergencyNoEscape = 0
		if(SSshuttle.emergency.mode == SHUTTLE_STRANDED)
			SSshuttle.emergency.mode = SHUTTLE_DOCKED
			SSshuttle.emergency.timer = world.time
			priority_announce("Hostile enviroment resolved. You have 3 minutes to board the Emergency Shuttle.", null, 'sound/AI/shuttledock.ogg', "Priority")
		for(var/obj/item/weapon/pinpointer/point in pinpointer_list)
			point.the_disk = null //Point back to the disk.

	if(doomsday_device)
		doomsday_device.timing = 0
		qdel(doomsday_device)
	if(explosive)
		spawn(10)
			explosion(src.loc, 3, 6, 12, 15)

	for(var/obj/machinery/ai_status_display/O in world) //change status
		if(src.key)
			O.mode = 2
			if (istype(loc, /obj/item/device/aicard))
				loc.icon_state = "aicard-404"

	tod = worldtime2text() //weasellos time of death patch
	if(mind)	mind.store_memory("Time of death: [tod]", 0)

	return ..(gibbed)
