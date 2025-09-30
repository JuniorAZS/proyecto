// js/main.js
document.addEventListener("DOMContentLoaded", () => {
  // Coloca año actual en footer
  const anioEl = document.getElementById("anio");
  if (anioEl) anioEl.textContent = new Date().getFullYear();

  // Marcar link activo en navbar
  const links = document.querySelectorAll(".navbar-nav .nav-link");
  links.forEach((link) => {
    if (
      link.getAttribute("href") === window.location.pathname.split("/").pop() ||
      (link.getAttribute("href") === "index.html" &&
        window.location.pathname.endsWith("/"))
    ) {
      link.classList.add("active");
    }
  });
});
