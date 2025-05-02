extends ProgressBar
class_name ExperienceBar


var current_exp_multiplier := 0.0


func drop_card(card : Card) -> void:
	var rarity_multiplier : float = Card.rarity_to_multiplier(card.rarity)
	match card.family:
		Card.CardFamilies.Military:
			RunData.gain_experience(
					RunData.level_experience_threshold / 5.0 * rarity_multiplier)
		Card.CardFamilies.Scientists:
			set_experience_multiplier(0.5 + rarity_multiplier/2.0, 30.0)
		Card.CardFamilies.Traders:
			RunData.current_combo += int(100 * rarity_multiplier)
		Card.CardFamilies.Revolution:
			RunData.current_experience = 0

func set_experience_multiplier(mult : float, duration : float) -> void:
	self_modulate = Color.DEEP_SKY_BLUE
	if current_exp_multiplier > 0:
		if current_exp_multiplier < mult:
			RunData.experience_multiplier += mult - current_exp_multiplier
			current_exp_multiplier = mult
	else:
		current_exp_multiplier = mult
		RunData.experience_multiplier += current_exp_multiplier
	if $TimerExperienceMult.is_stopped() or $TimerExperienceMult.time_left <= duration:
		$TimerExperienceMult.start(duration)

func _on_timer_experience_mult_timeout() -> void:
	RunData.experience_multiplier -= current_exp_multiplier
	self_modulate = Color.WHITE
