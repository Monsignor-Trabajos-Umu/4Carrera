"use strict";
// const { spawnSync } = require("child_process");
const system = require("system-commands");
const _ = require("lodash");
const imagenesA = [
  "C0837_0_des_def.bmp",
  "C0837_50_des_def.bmp",
  "C0837_100_des_def.bmp",
  "C0837_150_des_def.bmp",
  "C0837_200_des_def.bmp",
  "C0837_500_des_def.bmp",
];

const compara = (iA, iB, o) => {
  console.log(`magick compare -metric AE -fuzz 5% ${iA} ${iB} ${o}.png`);
  system(`magick compare -metric AE -fuzz 5% ${iA} ${iB} ${o}.png`)
    .then((output) => {
      // Log the output
      console.log(output);
    })
    .catch((error) => {
      // An error occurred! Log the error
      console.error(error);
    });
};

imagenesA.forEach((value) => {
  let comun = value.split("_");
  comun = comun[0] + "_" + comun[1];
  compara(value, "C0837.bmp", comun);
});
