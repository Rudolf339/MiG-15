# Radio Compass

#Note Radiocopass.xml file in Systems directory
#It's a part of instrument and gotta be added as explained in it

#Radiocompass.init_radiocompass(); gotta be called on manual aircraft restart

# helper 
stop_radiocompass = func {
  setprop("fdm/jsbsim/systems/radiocompass/lamp", 0);
  setprop("fdm/jsbsim/systems/radiocompass/degree", 0);
  setprop("fdm/jsbsim/systems/radiocompass/recieve-lamp", 0);

  setprop("sounds/radio-tune/on", 0);
  setprop("sounds/radio-morse/on", 0);
  setprop("sounds/radio-noise/on", 0);
  setprop("sounds/radio-noise/volume-norm", 0);
  setprop("sounds/radio-morse/volume-norm", 0);
  setprop("sounds/radio-tune/volume-norm", 0);
  setprop("sounds/radio-search-left/on", 0);
  setprop("sounds/radio-search-left/volume-norm", 0);
  setprop("sounds/radio-search-right/on", 0);
  setprop("sounds/radio-search-right/volume-norm", 0);
}

radiocompass = func {
  var frequency=[0, 1, 2];
  var low_frequency=[0, 1, 2];
  var high_frequency=[0, 1, 2];
  var high_frequency=[0, 1, 2];
  in_service = getprop("fdm/jsbsim/systems/radiocompass/serviceable" );
  if (in_service == nil)
  {
    stop_radiocompass();
    return ( settimer(radiocompass, 0.1) ); 
  }
  if ( in_service != 1 )
  {
    stop_radiocompass();
    return ( settimer(radiocompass, 0.1) ); 
  }
  power=getprop("systems/electrical-real/outputs/radiocompass/volts-norm");
  brightness=getprop("fdm/jsbsim/systems/radiocompass/brightness");
  loudness=getprop("fdm/jsbsim/systems/radiocompass/loudness");
  tg_loudness=getprop("fdm/jsbsim/systems/radiocompass/telegraph-loudness");
  tl_loudness=getprop("fdm/jsbsim/systems/radiocompass/telephone-loudness");
  degree=getprop("instrumentation/adf/indicated-bearing-deg");
  current_degree=getprop("fdm/jsbsim/systems/radiocompass/degree");
  frame_speed=getprop("fdm/jsbsim/systems/radiocompass/frame-speed");
  type=getprop("fdm/jsbsim/systems/radiocompass/type-switch");
  band=getprop("fdm/jsbsim/systems/radiocompass/band-switch");
  frequency[0]=getprop("fdm/jsbsim/systems/radiocompass/band[0]/frequency");
  low_frequency[0]=getprop("fdm/jsbsim/systems/radiocompass/band[0]/low-frequency");
  high_frequency[0]=getprop("fdm/jsbsim/systems/radiocompass/band[0]/high-frequency");
  frequency[1]=getprop("fdm/jsbsim/systems/radiocompass/band[1]/frequency");
  low_frequency[1]=getprop("fdm/jsbsim/systems/radiocompass/band[1]/low-frequency");
  high_frequency[1]=getprop("fdm/jsbsim/systems/radiocompass/band[1]/high-frequency");
  frequency[2]=getprop("fdm/jsbsim/systems/radiocompass/band[2]/frequency");
  low_frequency[2]=getprop("fdm/jsbsim/systems/radiocompass/band[2]/low-frequency");
  high_frequency[2]=getprop("fdm/jsbsim/systems/radiocompass/band[2]/high-frequency");
  vern=getprop("fdm/jsbsim/systems/radiocompass/frequency-vern");
  vern_prev=getprop("fdm/jsbsim/systems/radiocompass/frequency-vern-previous");
  ident=getprop("instrumentation/adf/ident");
  tg_or_tl=getprop("fdm/jsbsim/systems/radiocompass/tg-or-tl-switch");
  repeat_time=getprop("fdm/jsbsim/systems/radiocompass/repeat-time");
  wait_time=getprop("fdm/jsbsim/systems/radiocompass/wait-time");
  wait_degree_time=getprop("fdm/jsbsim/systems/radiocompass/wait-degree-time");
  if ((power==nil) 
   or (brightness==nil)
   or (loudness==nil)
   or (tg_loudness==nil)
   or (tl_loudness==nil)
   or (degree==nil)
   or (current_degree==nil)
   or (frame_speed==nil)
   or (type==nil)
   or (band==nil)
   or (frequency[0]==nil)
   or (low_frequency[0]==nil)
   or (high_frequency[0]==nil)
   or (frequency[1]==nil)
   or (low_frequency[1]==nil)
   or (high_frequency[1]==nil)
   or (frequency[2]==nil)
   or (low_frequency[2]==nil)
   or (high_frequency[2]==nil)
   or (vern==nil)
   or (vern_prev==nil)
   or (ident==nil)
   or (tg_or_tl==nil)
   or (repeat_time==nil)
   or (wait_time==nil)
   or (wait_degree_time==nil)
      )
  {
    stop_radiocompass();
    setprop("fdm/jsbsim/systems/radiocompass/error", 1);
    return ( settimer(radiocompass, 0.1) ); 
  }
  setprop("fdm/jsbsim/systems/radiocompass/error", 0);
  if (vern!=vern_prev)
  {
    step=vern-vern_prev;
    if (vern>360)
    {
      vern=vern-360;
    }
    if (vern<0)
    {
      vern=vern+360;
    }
    setprop("fdm/jsbsim/systems/radiocompass/frequency-vern", vern);
    setprop("fdm/jsbsim/systems/radiocompass/frequency-vern-previous", vern);
    frequency[band]=frequency[band]+step;
    if (frequency[band]>high_frequency[band])
    {
      frequency[band]=high_frequency[band];
    }
    if (frequency[band]<low_frequency[band])
    {
      frequency[band]=low_frequency[band];
    }
    setprop("fdm/jsbsim/systems/radiocompass/band["~band~"]/frequency", frequency[band]);
  }
  setprop("instrumentation/adf/frequencies/selected-khz", frequency[band]);
  setprop("fdm/jsbsim/systems/radiocompass/frequency", frequency[band]);
  for (var i=0; i < 3; i = i+1) 
  {
    if (band==i)
    {
      setprop("fdm/jsbsim/systems/radiocompass/band["~i~"]/active-input", 1);
    }
    else
    {
      setprop("fdm/jsbsim/systems/radiocompass/band["~i~"]/active-input", 0);
    }
  }
  if ((power==0) or (type==0))
  {
    setprop("fdm/jsbsim/systems/radiocompass/frequency", 0);
    setprop("fdm/jsbsim/systems/radiocompass/recieve-quality", 0);
    stop_radiocompass();
    setprop("fdm/jsbsim/systems/radiocompass/wait-time", 0);
    return ( settimer(radiocompass, repeat_time) ); 
  }
  setprop("fdm/jsbsim/systems/radiocompass/lamp", power*brightness);
  if ((type==1) or (type==3))
  {
    setprop("sounds/radio-tune/on", 0);
    setprop("sounds/radio-morse/on", 0);
    setprop("sounds/radio-noise/on", 0);
    if (ident=="")
    {
      setprop("fdm/jsbsim/systems/radiocompass/degree", 0);
      setprop("fdm/jsbsim/systems/radiocompass/recieve-lamp", 0);
      setprop("fdm/jsbsim/systems/radiocompass/recieve-quality", 0);
      setprop("sounds/radio-search-left/on", 0);
      setprop("sounds/radio-search-right/on", 0);
      setprop("fdm/jsbsim/systems/radiocompass/wait-time", 0);
    }
    else
    {
      if (wait_time<1)
      {
        wait_time=wait_time+0.1;
        setprop("fdm/jsbsim/systems/radiocompass/wait-time", wait_time);
      }
      else
      {

        if (abs(degree-current_degree)>100)
        {
          if (wait_degree_time<0.5)
          {
            wait_degree_time=wait_degree_time+0.1;
            setprop("fdm/jsbsim/systems/radiocompass/wait-degree-time", wait_degree_time);
            degree=current_degree;
          }
          else
          {
            setprop("fdm/jsbsim/systems/radiocompass/wait-degree-time", 0);
          }
        }
        else
        {
          setprop("fdm/jsbsim/systems/radiocompass/wait-degree-time", 0);
          if (type==1)
          {
            degree=current_degree+(degree-current_degree)*0.5;
          }
          else
          {
            degree=current_degree+(degree-current_degree)*abs(frame_speed);
          }
        }
        setprop("fdm/jsbsim/systems/radiocompass/degree", degree);
        setprop("fdm/jsbsim/systems/radiocompass/recieve-lamp", power*brightness);
        setprop("fdm/jsbsim/systems/radiocompass/recieve-quality", 1);
        right_volume=0.5*(1+math.sin(degree/180*math.pi));
        left_volume=1-right_volume;
        right_volume=right_volume*(0.5+
          0.25*(1+math.cos(degree/180*math.pi)));
        left_volume=left_volume*(0.5+
          0.25*(1+math.cos(degree/180*math.pi)));
        left_volume=left_volume*loudness;
        right_volume=right_volume*loudness;
        setprop("sounds/radio-search-left/volume-norm", left_volume);
        setprop("sounds/radio-search-right/volume-norm", right_volume);
        setprop("sounds/radio-noise/on", 0);
        setprop("sounds/radio-tune/on", 0);
        setprop("sounds/radio-morse/on", 0);
        setprop("sounds/radio-noise/volume-norm", 0);
        setprop("sounds/radio-morse/volume-norm", 0);
        setprop("sounds/radio-tune/volume-norm", 0);
        setprop("sounds/radio-search-left/on", 1);
        setprop("sounds/radio-search-right/on", 1);
      }
    }
  }
  if (type==2)
  {
    setprop("sounds/radio-search-left/on", 0);
    setprop("sounds/radio-search-right/on", 0);
    setprop("fdm/jsbsim/systems/radiocompass/wait-time", 0);
    setprop("fdm/jsbsim/systems/radiocompass/degree", 0);
    setprop("fdm/jsbsim/systems/radiocompass/recieve-lamp", 0);
    setprop("fdm/jsbsim/systems/radiocompass/recieve-quality", 0);
    if (ident=="")
    {
      setprop("sounds/radio-tune/on", 0);
      setprop("sounds/radio-morse/on", 0);
      if (tg_or_tl==1)
      {
        setprop("fdm/jsbsim/systems/radiocompass/noise-loudness", tl_loudness);
        setprop("sounds/radio-noise/volume-norm", tl_loudness);
      }
      else
      {
        setprop("fdm/jsbsim/systems/radiocompass/noise-loudness", tg_loudness);
        setprop("sounds/radio-noise/volume-norm", tg_loudness);
      }
      setprop("sounds/radio-noise/on", 1);
    }
    else
    {
      if (tg_or_tl==1)
      {
        setprop("sounds/radio-morse/on", 0);
        setprop("sounds/radio-tune/on", 1);
        setprop("sounds/radio-tune/volume-norm", tl_loudness);
      }
      else
      {
        setprop("sounds/radio-tune/on", 0);
        setprop("sounds/radio-morse/on", 1);
        setprop("sounds/radio-morse/volume-norm", tg_loudness);
      }
      setprop("sounds/radio-noise/on", 0);
      setprop("sounds/radio-noise/volume-norm", 0);
    }
  }
  settimer(radiocompass, repeat_time);
}

# set startup configuration
init_radiocompass=func
{
  setprop("fdm/jsbsim/systems/radiocompass/serviceable", 1);
  setprop("fdm/jsbsim/systems/radiocompass/lamp", 0);
  setprop("fdm/jsbsim/systems/radiocompass/brightness", 0.75);
  setprop("fdm/jsbsim/systems/radiocompass/loudness", 0.25);
  setprop("fdm/jsbsim/systems/radiocompass/telegraph-loudness", 0.75);
  setprop("fdm/jsbsim/systems/radiocompass/telephone-loudness", 0.75);
  setprop("fdm/jsbsim/systems/radiocompass/noise-loudness", 0.75);
  setprop("fdm/jsbsim/systems/radiocompass/degree", 0);
  setprop("fdm/jsbsim/systems/radiocompass/frequency", 0);
  setprop("fdm/jsbsim/systems/radiocompass/wait-time", 0);
  setprop("fdm/jsbsim/systems/radiocompass/wait-degree-time", 0);

  setprop("fdm/jsbsim/systems/radiocompass/type-input", 0);
  setprop("fdm/jsbsim/systems/radiocompass/type-input-mult", 0);
  setprop("fdm/jsbsim/systems/radiocompass/type-command", 0);
  setprop("fdm/jsbsim/systems/radiocompass/type-command", 0);
  setprop("fdm/jsbsim/systems/radiocompass/type-switch", 0);

  setprop("fdm/jsbsim/systems/radiocompass/band-input", 0);
  setprop("fdm/jsbsim/systems/radiocompass/band-input-mult", 0);
  setprop("fdm/jsbsim/systems/radiocompass/band-command", 0);
  setprop("fdm/jsbsim/systems/radiocompass/band-command", 0);
  setprop("fdm/jsbsim/systems/radiocompass/band-switch", 0);

  setprop("fdm/jsbsim/systems/radiocompass/band[0]/scale-shift", 1);
  setprop("fdm/jsbsim/systems/radiocompass/band[0]/scale-pos", 1);
  setprop("fdm/jsbsim/systems/radiocompass/band[0]/frequency", 150);
  setprop("fdm/jsbsim/systems/radiocompass/band[0]/low-frequency", 150);
  setprop("fdm/jsbsim/systems/radiocompass/band[0]/high-frequency", 310);

  setprop("fdm/jsbsim/systems/radiocompass/band[1]/scale-shift", 0);
  setprop("fdm/jsbsim/systems/radiocompass/band[1]/scale-pos", 0);
  setprop("fdm/jsbsim/systems/radiocompass/band[1]/frequency", 310);
  setprop("fdm/jsbsim/systems/radiocompass/band[1]/low-frequency", 310);
  setprop("fdm/jsbsim/systems/radiocompass/band[1]/high-frequency", 640);

  setprop("fdm/jsbsim/systems/radiocompass/band[2]/scale-shift", 0);
  setprop("fdm/jsbsim/systems/radiocompass/band[2]/scale-pos", 0);
  setprop("fdm/jsbsim/systems/radiocompass/band[2]/frequency", 640);
  setprop("fdm/jsbsim/systems/radiocompass/band[2]/low-frequency", 640);
  setprop("fdm/jsbsim/systems/radiocompass/band[2]/high-frequency", 1300);


  setprop("fdm/jsbsim/systems/radiocompass/tg-or-tl-input", 0);
  setprop("fdm/jsbsim/systems/radiocompass/tg-or-tl-command", 0);
  setprop("fdm/jsbsim/systems/radiocompass/tg-or-tl-pos", 0);
  setprop("fdm/jsbsim/systems/radiocompass/tg-or-tl-switch", 0);

  setprop("fdm/jsbsim/systems/radiocompass/frequency-vern", 0);
  setprop("fdm/jsbsim/systems/radiocompass/frequency-vern-previous", 0);
  setprop("fdm/jsbsim/systems/radiocompass/recieve-lamp", 0);
  setprop("fdm/jsbsim/systems/radiocompass/recieve-quality", 0);
  setprop("fdm/jsbsim/systems/radiocompass/frame-speed", 0.5);
  setprop("fdm/jsbsim/systems/radiocompass/repeat-time", 0.1);

  setprop("sounds/radio-tune/on", 0);
  setprop("sounds/radio-morse/on", 0);
  setprop("sounds/radio-noise/on", 0);
  setprop("sounds/radio-noise/volume-norm", 0);
  setprop("sounds/radio-morse/volume-norm", 0);
  setprop("sounds/radio-tune/volume-norm", 0);

  setprop("sounds/radio-search-left/on", 0);
  setprop("sounds/radio-search-left/volume-norm", 0);
  setprop("sounds/radio-search-right/on", 0);
  setprop("sounds/radio-search-right/volume-norm", 0);
}

# set startup configuration
start_radiocompass = func {
  init_radiocompass();
  radiocompass();
}
