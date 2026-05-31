const score_url_prefix='https://raw.githubusercontent.com/metropolis-project/metropolis-score/refs/heads/master/';
const scores = [
"metropolis-01-auftakt-000-000.musicxml",
"metropolis-02-auftakt-001-001.musicxml",
"metropolis-02-auftakt-002-003.musicxml",
"metropolis-03-auftakt-004-006.musicxml",
"metropolis-04-auftakt-006-014.musicxml",
"metropolis-05-auftakt-015-021.musicxml",
"metropolis-06-auftakt-022-026.musicxml",
"metropolis-06-auftakt-027-027.musicxml",
"metropolis-06-auftakt-028-034.musicxml",
"metropolis-07-auftakt-035-036.musicxml",
"metropolis-07-auftakt-037-044.musicxml",
"metropolis-08-auftakt-045-055.musicxml",
"metropolis-09-auftakt-056-062.musicxml",
"metropolis-10-auftakt-062-066.musicxml",
"metropolis-11-auftakt-067-071.musicxml",
"metropolis-12-auftakt-072-074.musicxml",
"metropolis-13-auftakt-075-080.musicxml",
"metropolis-14-auftakt-081-083.musicxml",
"metropolis-15-auftakt-084-084.musicxml",
"metropolis-16-auftakt-085-090.musicxml",
"metropolis-17-auftakt-091-091.musicxml",
"metropolis-18-auftakt-092-097.musicxml",
"metropolis-19-auftakt-098-104.musicxml",
"metropolis-20-zwischenspiel-000-000.musicxml",
"metropolis-20-zwischenspiel-001-001.musicxml",
"metropolis-20-zwischenspiel-002-002.musicxml",
"metropolis-20-zwischenspiel-003-003.musicxml",
"metropolis-21-zwischenspiel-004-004.musicxml",
"metropolis-21-zwischenspiel-005-007.musicxml",
"metropolis-22-zwischenspiel-008-009.musicxml",
"metropolis-22-zwischenspiel-009-017.musicxml",
"metropolis-23-zwischenspiel-017-021.musicxml",
"metropolis-24-zwischenspiel-022-024.musicxml",
"metropolis-24-zwischenspiel-025-027.musicxml",
"metropolis-25-zwischenspiel-028-032.musicxml",
"metropolis-26-zwischenspiel-033-034.musicxml",
"metropolis-27-zwischenspiel-034-035.musicxml",
"metropolis-28-zwischenspiel-035-037.musicxml",
"metropolis-29-zwischenspiel-038-039.musicxml",
"metropolis-30-zwischenspiel-040-045.musicxml",
"metropolis-31-zwischenspiel-046-048.musicxml",
"metropolis-32-furioso-001-003.musicxml",
"metropolis-33-furioso-004-011.musicxml",
"metropolis-34-furioso-011-017.musicxml",
"metropolis-35-furioso-018-023.musicxml",
"metropolis-36-furioso-024-035.musicxml",
"metropolis-37-furioso-035-038.musicxml",
"metropolis-38-furioso-039-042.musicxml",
"metropolis-39-furioso-042-046.musicxml",
"metropolis-40-furioso-046-057.musicxml",
"metropolis-41-furioso-058-059.musicxml",
"metropolis-42-furioso-059-065.musicxml",
"metropolis-43-furioso-065-083.musicxml",
"metropolis-44-furioso-082-083.musicxml",
"metropolis-45-furioso-084-087.musicxml",
"metropolis-46-furioso-088-092.musicxml",
"metropolis-47-furioso-093-094.musicxml",
"metropolis-48-furioso-094-102.musicxml",
"metropolis-49-furioso-102-111.musicxml",
"metropolis-50-furioso-112-114.musicxml",
"metropolis-51-furioso-115-126.musicxml",
"metropolis-52-furioso-127-130.musicxml",
];
var scoreIndex = 0;

document.addEventListener("DOMContentLoaded", async () => {
  const osmd = new opensheetmusicdisplay.OpenSheetMusicDisplay("osmd-container", { autoResize: false, followCursor: true });
  const audioPlayer = new OsmdAudioPlayer();

  // Monkey-patch to track the exact end time of all scheduled notes
  let lastNoteEndTime = 0;
  const originalSchedule = audioPlayer.instrumentPlayer.schedule.bind(audioPlayer.instrumentPlayer);
  audioPlayer.instrumentPlayer.schedule = (midiId, time, notes) => {
    notes.forEach(n => {
      const endTime = time + n.duration;
      if (endTime > lastNoteEndTime) {
        lastNoteEndTime = endTime;
      }
    });
    originalSchedule(midiId, time, notes);
  };

  // Monkey-patch to add 'end-of-score' event
  const originalIterationCallback = audioPlayer.iterationCallback.bind(audioPlayer);
  audioPlayer.iterationCallback = () => {
    originalIterationCallback();
    if (audioPlayer.currentIterationStep >= audioPlayer.iterationSteps) {
      const checkEnd = () => {
        if (audioPlayer.state !== 'PLAYING') return;
        const currentTime = audioPlayer.ac.currentTime;
        if (currentTime < lastNoteEndTime) {
          setTimeout(checkEnd, Math.max(10, (lastNoteEndTime - currentTime) * 1000));
        } else {
          // Emit through the player's own event system
          if (audioPlayer.events && typeof audioPlayer.events.emit === 'function') {
            audioPlayer.events.emit('end-of-score');
          }
        }
      };
      checkEnd();
    }
  };

  const btnPlay = document.getElementById('btn-play');
  const btnPause = document.getElementById('btn-pause');
  const btnStop = document.getElementById('btn-stop');
  const btnPrev = document.getElementById('btn-prev');
  const btnNext = document.getElementById('btn-next');

  async function load_next_score() {
    const response = await fetch(score_url_prefix + scores[scoreIndex]);
    if (!response.ok) {
      throw new Error(`Failed to load score at index ${scoreIndex}: ${response.statusText}`);
    }
    const score = await response.text();
    await osmd.load(score);
    osmd.render();
    await audioPlayer.loadScore(osmd);
    lastNoteEndTime = 0; // Reset for new score
  }

  async function skip_to_score(indexOffset) {
    const wasPlaying = audioPlayer.state === 'PLAYING';
    scoreIndex = (scoreIndex + indexOffset + scores.length) % scores.length;
    await audioPlayer.stop();
    await load_next_score();
    if (wasPlaying) {
      await audioPlayer.play();
    }
  }

  async function init() {
    audioPlayer.on('state-change', (state) => {
      console.log("Playback state: " + state);
      if (state === 'PLAYING') {
        btnPlay.disabled = true;
        btnPause.disabled = false;
      } else {
        btnPlay.disabled = false;
        btnPause.disabled = true;
      }
    });

    // Use our new monkey-patched event
    audioPlayer.on('end-of-score', async () => {
      console.log("Playback finished (end-of-score)");
      scoreIndex = (scoreIndex + 1) % scores.length;
      await audioPlayer.stop();
      await load_next_score();
      await audioPlayer.play();
    });

    await load_next_score();
  }

  btnPlay.addEventListener('click', async () => {
    if (audioPlayer.state === 'STOPPED' || audioPlayer.state === 'PAUSED') {
      await audioPlayer.play();
    }
  });

  btnPause.addEventListener('click', () => {
    audioPlayer.pause();
  });

  btnStop.addEventListener('click', () => {
    audioPlayer.stop();
  });

  btnPrev.addEventListener('click', () => skip_to_score(-1));
  btnNext.addEventListener('click', () => skip_to_score(1));

  init();
});
