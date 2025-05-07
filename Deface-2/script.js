// === CONFIGURE LAUNCH DATE HERE ===
const launchDate = new Date("May 02, 2025 11:30:00").getTime();

function updateCountdown() {
  const now = new Date().getTime();
  const distance = launchDate - now;

  if (distance <= 0) {
    document.getElementById("timer").innerHTML = "🚀 Launched!";
    return;
  }

  const days = Math.floor(distance / (1000 * 60 * 60 * 24));
  const hours = Math.floor((distance / (1000 * 60 * 60)) % 24);
  const minutes = Math.floor((distance / (1000 * 60)) % 60);
  const seconds = Math.floor((distance / 1000) % 60);

  const pad = (n) => (n < 10 ? "0" + n : n);

  document.getElementById("timer").innerHTML =
    `${pad(days)}d : ${pad(hours)}h : ${pad(minutes)}m : ${pad(seconds)}s`;
}

// Open modal automatically on page load
window.onload = () => {
  document.getElementById("security-alert").style.display = "block";

  // Close modal
  document.getElementById("modal-close").onclick = () => {
    document.getElementById("security-alert").style.display = "none";
  };

  updateCountdown();
  setInterval(updateCountdown, 1000);
};
