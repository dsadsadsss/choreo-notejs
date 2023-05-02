const { spawn } = require('child_process');

const startScript = spawn('/start.sh');

startScript.stdout.on('data', (data) => {
  console.log(`输出：${data}`);
});

startScript.stderr.on('data', (data) => {
  console.error(`错误：${data}`);
});

startScript.on('close', (code) => {
  console.log(`子进程退出，退出码 ${code}`);
});
