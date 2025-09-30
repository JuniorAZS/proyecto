// js/reservas.js
document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("formReservas");
  const cardConfirmacion = document.getElementById("cardConfirmacion");
  const detalleCita = document.getElementById("detalleCita");
  const toastEl = document.getElementById("toastReserva");
  const toast = new bootstrap.Toast(toastEl);
  const especialidadSelect = document.getElementById("especialidad");

  // Prellenar especialidad desde query param
  const params = new URLSearchParams(window.location.search);
  if (params.has("especialidad")) {
    const valor = params.get("especialidad");
    [...especialidadSelect.options].forEach((opt) => {
      if (opt.text === valor) opt.selected = true;
    });
  }

  // Validar y confirmar
  form.addEventListener("submit", (e) => {
    e.preventDefault();
    if (!form.checkValidity()) {
      e.stopPropagation();
      form.classList.add("was-validated");
      return;
    }

    const nombre = document.getElementById("nombre").value.trim();
    const dni = document.getElementById("dni").value.trim();
    const especialidad = especialidadSelect.value;
    const fecha = document.getElementById("fecha").value;
    const hora = document.getElementById("hora").value;
    const medicoSelect = document.getElementById("medico");
    const medicoId = medicoSelect.value;
    const medicoNombre = medicoSelect.options[medicoSelect.selectedIndex].text;

    // Guardar en localStorage
    const nuevaCita = { nombre, dni, especialidad, medicoNombre, fecha, hora };
    const citas = JSON.parse(localStorage.getItem("citas")) || [];
    citas.push(nuevaCita);
    localStorage.setItem("citas", JSON.stringify(citas));

    // Mostrar Card resumen
    detalleCita.innerHTML = `
    <strong>${nombre}</strong> (${dni})<br>
    Especialidad: ${especialidad}<br>
    Médico: ${medicoNombre}<br>
    Fecha: ${fecha} • Hora: ${hora}
    `;
    cardConfirmacion.classList.remove("d-none");
    // Mostrar Toast
    toast.show();

    // Resetear formulario
    form.reset();
    form.classList.remove("was-validated");
  });
});
