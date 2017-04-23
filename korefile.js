let fs = require('fs');
let path = require('path');
let project = new Project('Empty', __dirname);
project.targetOptions = {"html5":{},"flash":{},"android":{},"ios":{}};
project.setDebugDir('build/windows');
Promise.all([Project.createProject('build/windows-build', __dirname), Project.createProject('C:/Users/JuanRinaudo/Desktop/Development/kge/Kha', __dirname), Project.createProject('C:/Users/JuanRinaudo/Desktop/Development/kge/Kha/Kore', __dirname)]).then((projects) => {
	for (let p of projects) project.addSubProject(p);
	let libs = [];
	if (fs.existsSync(path.join('C:/HaxeToolkit/haxe/lib/zui', 'korefile.js'))) {
		libs.push(Project.createProject('C:/HaxeToolkit/haxe/lib/zui', __dirname));
	}
	if (fs.existsSync(path.join('C:/HaxeToolkit/haxe/lib/polygonal-ds', 'korefile.js'))) {
		libs.push(Project.createProject('C:/HaxeToolkit/haxe/lib/polygonal-ds', __dirname));
	}
	if (fs.existsSync(path.join('C:/HaxeToolkit/haxe/lib/polygonal-printf', 'korefile.js'))) {
		libs.push(Project.createProject('C:/HaxeToolkit/haxe/lib/polygonal-printf', __dirname));
	}
	Promise.all(libs).then((libprojects) => {
		for (let p of libprojects) project.addSubProject(p);
		resolve(project);
	});
});
