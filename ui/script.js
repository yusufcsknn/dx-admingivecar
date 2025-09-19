window.addEventListener("message", (event) => {
  if (event.data.action === "open") {
    document.getElementById("menu").classList.remove("hidden");
  }
});

function closeUI() {
  document.getElementById("menu").classList.add("hidden");
  fetch(`https://dx-admingivecar/close`, { method: "POST" });
}

// HEX → RGB dönüşüm
function hexToRgb(hex) {
  const bigint = parseInt(hex.replace("#", ""), 16);
  return {
    r: (bigint >> 16) & 255,
    g: (bigint >> 8) & 255,
    b: bigint & 255,
  };
}

document.getElementById("close").addEventListener("click", () => {
  closeUI();
});

document.getElementById("spawn").addEventListener("click", () => {
  const playerId = document.getElementById("playerId").value;
  const model = document.getElementById("model").value;
  const plate = document.getElementById("plate").value;
  const color1 = document.getElementById("color1").value;

  const rgb1 = hexToRgb(color1);

  fetch(`https://dx-admingivecar/spawnCar`, {
    method: "POST",
    body: JSON.stringify({ playerId, model, plate, color1: rgb1 }),
  });

  closeUI();
});
