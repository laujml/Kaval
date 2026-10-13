/// Fechas cortas al estilo del mockup: "2–4 oct" / "2–4 Oct".
String mesCorto(DateTime fecha, String idioma) {
  const es = [
    'ene', 'feb', 'mar', 'abr', 'may', 'jun',
    'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
  ];
  const en = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  final lista = idioma == 'en' ? en : es;
  return lista[fecha.month - 1];
}

String rangoFechas(DateTime inicio, DateTime fin, String idioma) {
  final mes = mesCorto(inicio, idioma);
  if (inicio.year == fin.year && inicio.month == fin.month) {
    return '${inicio.day}–${fin.day} $mes';
  }
  return '${inicio.day} $mes – ${fin.day} ${mesCorto(fin, idioma)}';
}

String fechaConAnio(DateTime fecha, String idioma) {
  return '${fecha.day} ${mesCorto(fecha, idioma)} ${fecha.year}';
}
