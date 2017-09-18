function vessel = post_setup_hook(vessel)

func = [vessel.cruise '_post_setup_hook'];
if exist(func)==2
    vessel = feval(func,vessel);
end
