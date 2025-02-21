db.envio.aggregate([
  { $match: {} },
  { $unionWith: "BA_201001" },
  { $unionWith: "BA_201002" },
  { $unionWith: "BA_201003" },
  { $unionWith: "BA_201004" },
  { $unionWith: "BA_201005" },
  { $unionWith: "BA_201006" },
  { $unionWith: "BA_201007" },
  { $unionWith: "BA_201008" },
  { $unionWith: "BA_201009" },
  { $unionWith: "BA_201010" },
  { $unionWith: "BA_201011" },  
  { $unionWith: "BA_201012" },  
  { $project: {_id: 0 } }, // Proyecta todos los campos excepto _id para evitar conflictos
  { $out: "BA_2010" }  // Escribe el resultado en la nueva colección
]);


db.A_201001_USER.aggregate([
  { $match: {} },
  { $unionWith: "A_201002_USER" },
  { $unionWith: "A_201003_USER" },
  { $unionWith: "A_201004_USER" },
  { $unionWith: "A_201005_USER" },
  { $unionWith: "A_201006_USER" },
  { $unionWith: "A_201007_USER" },
  { $unionWith: "A_201008_USER" },
  { $unionWith: "A_201009_USER" },
  { $unionWith: "A_201010_USER" },
  { $unionWith: "A_201011_USER" },  
  { $unionWith: "A_201012_USER" },  
  { $project: {_id: 0 } }, // Proyecta todos los campos excepto _id para evitar conflictos
  { $out: "USER_2010" }  // Escribe el resultado en la nueva colección
]);




db.USER_2010.aggregate([
  {
    $lookup: {
      from: "usuario",
      localField: "usuario_id",
      foreignField: "usuario_id",
      as: "matched_users"
    }
  },
  {
    $match: {
      matched_users: { $size: 0 } // Filtra los documentos sin coincidencias
    }
  },
  {
    $project: {
      _id: 0, // Puedes incluir otros campos aquí
    }
  },
  { $out: "user_new_2010" }  // Escribe el resultado en la nueva colección  
])