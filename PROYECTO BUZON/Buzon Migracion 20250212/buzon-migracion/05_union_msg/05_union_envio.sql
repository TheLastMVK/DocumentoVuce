db.envio.aggregate([
  { $match: {} },
  { $unionWith: "envio_201901" },
  { $unionWith: "envio_201902" },
  { $unionWith: "envio_201903" },
  { $unionWith: "envio_201904" },
  { $unionWith: "envio_201905" },
  { $unionWith: "envio_201906" },
  { $unionWith: "envio_201907" },
  { $unionWith: "envio_201908" },
  { $unionWith: "envio_201909" },
  { $unionWith: "envio_201910" },
  { $unionWith: "envio_201911" },  
  { $unionWith: "envio_201912" },  
  { $project: {_id: 0 } }, // Proyecta todos los campos excepto _id para evitar conflictos
  { $out: "envio_2019" }  // Escribe el resultado en la nueva colección
]);


db.user_201901.aggregate([
  { $match: {} },
  { $unionWith: "user_201902" },
  { $unionWith: "user_201903" },
  { $unionWith: "user_201904" },
  { $unionWith: "user_201905" },
  { $unionWith: "user_201906" },
  { $unionWith: "user_201907" },
  { $unionWith: "user_201908" },
  { $unionWith: "user_201909" },
  { $unionWith: "user_201910" },
  { $unionWith: "user_201911" },  
  { $unionWith: "user_201912" },  
  { $project: {_id: 0 } }, // Proyecta todos los campos excepto _id para evitar conflictos
  { $out: "user_2019" }  // Escribe el resultado en la nueva colección
]);
