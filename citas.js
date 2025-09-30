// js/citas.js
document.addEventListener("DOMContentLoaded", () => {
  const tablaBody = document.querySelector("#tablaCitas tbody");
  const sinCitasMsg = document.getElementById("sinCitas");
  const citas = JSON.parse(localStorage.getItem("citas")) || [];

  if (citas.length === 0) {
    sinCitasMsg.classList.remove("d-none");
    return;
  }

  citas.forEach((cita, index) => {
    const fila = document.createElement("tr");
    fila.innerHTML = `
        <td>${cita.nombre}</td>
        <td>${cita.dni}</td>
        <td>${cita.especialidad}</td>
        <td>${cita.fecha}</td>
        <td>${cita.hora}</td>
        <td><span class="badge bg-warning">Pendiente</span></td>
        <td>
          <button class="btn btn-sm btn-danger" data-index="${index}">
            🗑️ Eliminar
          </button>
        </td>
      `;
    tablaBody.appendChild(fila);
  });

  // Eliminar sin recargar
  tablaBody.addEventListener("click", (e) => {
    if (e.target.closest("button")) {
      const idx = e.target.closest("button").getAttribute("data-index");
      citas.splice(idx, 1);
      localStorage.setItem("citas", JSON.stringify(citas));
      e.target.closest("tr").remove();
      if (citas.length === 0) sinCitasMsg.classList.remove("d-none");
    }
  });
});
