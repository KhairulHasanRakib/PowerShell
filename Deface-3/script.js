
const launchDate = new Date("May 09, 2025 11:30:00").getTime();

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

function openModal() {
  document.getElementById("security-alert").style.display = "block";
}

function closeModal() {
  document.getElementById("security-alert").style.display = "none";
}

window.onload = function () {
  openModal();
  setInterval(updateCountdown, 1000);
  updateCountdown();
};