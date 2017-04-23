package kge.core;

import kha.Sound;
import kha.audio1.AudioChannel;
import kha.audio2.Audio1;

class AudioManager extends CoreBase
{	

	private var audios:Array<AudioChannel>;
	private var audioTimes:Array<Float>;
	private var audioTimesEnd:Array<Float>;

	public function new() 
	{
		super();
		
		audios = [];
		audioTimes = [];
		audioTimesEnd = [];
	}
	
	override public function update() 
	{
		super.update();
		
		var audio:AudioChannel;
		var time:Float;
		var endTime:Float;
		for (i in 0...audios.length) {
			audio = audios[i];			
			
			if(audio != null) {
				audioTimes[i] += Game.deltaTime;
				time = audioTimes[i];
				endTime = audioTimesEnd[i];
				if (endTime > 0 && time > endTime) {
					audio.stop();
				}
				
				if (audio.finished) {
					audios.remove(audio);
					audioTimes.splice(i, 1);
					audioTimesEnd.splice(i, 1);
				}
			}
		}		
	}
	
	public function playSound(sound:Sound, loop:Bool = false):AudioChannel {
		return playSoundSection(sound, -1, loop);
	}
	
	public function playSoundSection(sound:Sound, end:Float, loop:Bool = false):AudioChannel {
		var audio:AudioChannel = Audio1.play(sound, loop);
		audios.push(audio);
		audioTimes.push(0);
		audioTimesEnd.push(end);
		return audio;
	}
	
	public function pauseAll() {
		for (audio in audios) {
			audio.pause();
		}
	}
	
	public function resumeAll() {
		for (audio in audios) {
			audio.play();
		}		
	}
	
}