const Api = require('kubernetes-client');
const core = new Api.Extensions({
  url:  'fillmein',
  namespace: 'pelias-dev', // Defaults to 'default'
  insecureSkipTlsVerify: true,
  auth: {
    user: 'admin',
    pass: 'fillmein'
  }
});

function print(err, result) {
    console.log(JSON.stringify(err || result, null, 2));
}

const patch = {
  body: {
    spec: {
      template: {
        spec: {
          containers: [
            {
              name: "pelias-api",
              image: "pelias/api:dockerfile-2017-08-28-a658c34dd4d9011aa0773be5796720f7c4da69f4"
            }
          ]
        }
      }
    }
  }
};
core.namespaces.deployments('pelias-api').patch(patch, print);
