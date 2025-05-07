// === CONFIGURE LAUNCH DATE HERE ===
const launchDate = new Date("May 02, 2025 11:30:00 AM").getTime();

// const launchDate = new Date("May 01, 2025 23:59:59").getTime(); // Just edit this line

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

  // Pad with zero if needed
  const pad = (n) => (n < 10 ? "0" + n : n);

  // Output formatted countdown
  document.getElementById("timer").innerHTML = 
    `${pad(days)}d : ${pad(hours)}h : ${pad(minutes)}m : ${pad(seconds)}s`;
}


// Function to open the modal
function openModal() {
  document.getElementById("security-alert").style.display = "block";
}

// Function to close the modal
function closeModal() {
  document.getElementById("security-alert").style.display = "none";
}

// Automatically open the modal when a security issue is detected
window.onload = function() {
  // Add your conditions for detecting a security issue here
  openModal();
};



// Run every second
setInterval(updateCountdown, 1000);
updateCountdown(); // Run once immediately on load
