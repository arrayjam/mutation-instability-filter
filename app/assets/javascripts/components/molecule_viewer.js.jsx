function initGLMol() {
  $("#glmol01_src").val("");
  $("#glmol01 canvas").remove();
  window.glmol01 = new GLmol('glmol01', true);
  glmol01.defineRepresentation = function() {
    var all = this.getAllAtoms();
    var hetatm = this.removeSolvents(this.getHetatms(all));
    this.colorByAtom(all, {});
    this.colorByChain(all);
    var asu = new THREE.Object3D();

    this.drawCartoon(asu, all, this.curveWidth, this.thickness);

    this.drawSymmetryMates2(this.modelGroup, asu, this.protein.biomtMatrices);
    this.modelGroup.add(asu);
  };
}
initGLMol();

function selectMol(s_id, m_id, mutation) {
  d3.xhr("/pdb_file/" + s_id + "/" + m_id, function(err, data) {
    var pdb = data.responseText;
    initGLMol();
    $("#glmol01_src").val(pdb);
    glmol01.loadMolecule();
    $("#viewer").text("Viewing mutation: " + mutation);
  });
}
