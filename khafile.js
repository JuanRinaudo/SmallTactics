let project = new Project('Empty');

project.addLibrary('zui');
project.addLibrary('tweenxcore');

project.addAssets('Assets/Common/**')
project.addAssets('Assets/LudumDare38/**')

project.addSources('Sources');

resolve(project);