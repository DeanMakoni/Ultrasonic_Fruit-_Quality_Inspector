var express = require('express'),
  router = express.Router(),
  resources = require('./../resources/model');

router.route('/').get(function (req, res, next) {
  req.result = resources.pi.instructions;
  next();
});

router.route('/traineddata').post(function (req, res, next) {
   const { execFile } = require('child_process');

  execFile('/home/pi/API/processNodejsImage.sh', (error, stdout, stderr) => {
    if (error) {
      console.error(`error: ${error.message}`);
      return;
    }

    if (stderr) {
      console.error(`stderr: ${stderr}`);
      return;
    }

   console.log(`stdout:\n${stdout}`);
  });

  next();
});


router.route('/receivedecho').get(function (req, res, next) {
   const { execFile } = require('child_process');

  execFile('/home/pi/API/processNodejsImage.sh', (error, stdout, stderr) => {
    if (error) {
      console.error(`error: ${error.message}`);
      return;
    }

    if (stderr) {
      console.error(`stderr: ${stderr}`);
      return;
    }

   console.log(`stdout:\n${stdout}`);
  });

  next();
});

router.route('/image').get(function (req, res, next) {
   const { execFile } = require('child_process');

  execFile('/home/pi/API/processNodejsImage.sh', (error, stdout, stderr) => {
    if (error) {
      console.error(`error: ${error.message}`);
      return;
    }

    if (stderr) {
      console.error(`stderr: ${stderr}`);
      return;
    }

   console.log(`stdout:\n${stdout}`);
  });

  next();
});

module.exports = router;
