const selectEspecialidad = document.getElementById("especialidad");
const selectMedico = document.getElementById("medico");

selectEspecialidad.addEventListener("change", () => {
  const especialidadSeleccionada = selectEspecialidad.value;

  // Reiniciar médicos
  selectMedico.innerHTML = "";

  if (especialidadSeleccionada) {
    // Filtrar doctores por especialidad
    const medicosFiltrados = listDocs.filter(
      (doc) => doc.especialidad === especialidadSeleccionada
    );

    if (medicosFiltrados.length > 0) {
      selectMedico.disabled = false;

      // Opción inicial
      const opcionDefault = document.createElement("option");
      opcionDefault.value = "";
      opcionDefault.textContent = "Seleccione un médico";
      selectMedico.appendChild(opcionDefault);

      // Insertar médicos filtrados
      medicosFiltrados.forEach((doc) => {
        const opcion = document.createElement("option");
        opcion.value = doc.id; // guardamos el id
        opcion.textContent = doc.nomcompletos; // mostramos nombre
        selectMedico.appendChild(opcion);
      });
    }
  } else {
    selectMedico.disabled = true;
    const opcion = document.createElement("option");
    opcion.textContent = "Seleccione una especialidad primero";
    selectMedico.appendChild(opcion);
  }
});

const doctorInfo = document.getElementById("doctorInfo");
const doctorImg = document.getElementById("doctorImg");
const doctorNombre = document.getElementById("doctorNombre");
const doctorEspecialidad = document.getElementById("doctorEspecialidad");
const doctorCorreo = document.getElementById("doctorCorreo");
const doctorTelefono = document.getElementById("doctorTelefono");
const doctorConsultorio = document.getElementById("doctorConsultorio");

// Cuando seleccionan un médico, mostrar su info
selectMedico.addEventListener("change", () => {
  const idMedico = parseInt(selectMedico.value);
  const doctor = listDocs.find((doc) => doc.id === idMedico);

  if (doctor) {
    doctorImg.src = doctor.img;
    doctorNombre.textContent = doctor.nomcompletos;
    doctorEspecialidad.textContent = `Especialidad: ${doctor.especialidad}`;
    doctorCorreo.textContent = `Correo: ${doctor.correo}`;
    doctorTelefono.textContent = `Teléfono: ${doctor.telefonono}`;
    doctorConsultorio.textContent = `Consultorio: ${doctor.consultorio}`;

    doctorInfo.classList.remove("d-none");
  } else {
    doctorInfo.classList.add("d-none");
  }
});
