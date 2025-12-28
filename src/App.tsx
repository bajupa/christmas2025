import { createSignal, onMount } from 'solid-js'
import './App.css'
import { PitchDetector } from 'pitchy'

function App() {
	const [_, setPitch] = createSignal(0)
	const [loudness, setLoudness] = createSignal(0)
	let audioElement: HTMLAudioElement

	onMount(() => {
		const audioContext = new window.AudioContext()
		const source = audioContext.createMediaElementSource(audioElement)
		const analyser = audioContext.createAnalyser()
		analyser.fftSize = 2048
		source.connect(analyser)
		analyser.connect(audioContext.destination)

		audioElement.addEventListener('play', () => {
			audioContext.resume()
		})

		const bufferLength = analyser.fftSize
		const buffer = new Float32Array(bufferLength)
		const detector = PitchDetector.forFloat32Array(bufferLength)

		function updatePitch() {
			analyser.getFloatTimeDomainData(buffer)

			const [pitch, _] = detector.findPitch(buffer, audioContext.sampleRate)
			setPitch(pitch / 100)

			let sum = 0
			for (let i = 0; i < bufferLength; i++) {
				sum += buffer[i] * buffer[i]
			}

			const rms = Math.sqrt(sum / bufferLength)
			setLoudness(loudness() * 0.8 + rms * 0.2)

			requestAnimationFrame(updatePitch)
		}

		updatePitch()
	})


	return (
		<>
			<div class='flex justify-center items-center h-screen flex-col gap-4 transform'>
				<audio ref={(el) => audioElement = el} id='audio' src='song.mp3' controls />
				<div class='relative w-3/4'>
					<img src='christmas.svg' class='absolute top-0 left-0 w-full z-10 sepia object-cover overflow-hidden object-top' style={{ height: `${100 - (loudness() / 0.15) * 100}%` }} />
					<img src='christmas.svg' class='opacity-50' />
				</div>
			</div>
		</>
	)
}

export default App
