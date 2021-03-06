/obj/effect/blob/factory
	name = "factory blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_factory"
	desc = "A thick spire of tendrils."
	health = 200
	maxhealth = 200
	health_regen = 1
	point_return = 25
	var/list/spores = list()
	var/max_spores = 3
	var/spore_delay = 0


/obj/effect/blob/factory/Destroy()
	for(var/mob/living/simple_animal/hostile/blob/blobspore/spore in spores)
		if(spore.factory == src)
			spore.factory = null
	spores = null
	return ..()

/obj/effect/blob/factory/Be_Pulsed()
	. = ..()
	if(spores.len >= max_spores)
		return
	if(spore_delay > world.time)
		return
	flick("factory_glow", src)
	spore_delay = world.time + 100 // 10 seconds
	var/mob/living/simple_animal/hostile/blob/blobspore/BS = new/mob/living/simple_animal/hostile/blob/blobspore(src.loc, src)
	if(overmind) //if we don't have an overmind, we don't need to do anything but make a spore
		BS.overmind = overmind
		BS.update_icons()
		overmind.blob_mobs.Add(BS)
