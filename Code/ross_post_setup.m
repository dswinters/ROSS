function Ross = ross_post_setup(Ross,trip)

setup_post_fun = [trip.name '_post_setup'];
if exist(setup_post_fun)==2
    Ross = feval(setup_post_fun,Ross);
end
