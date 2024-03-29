#
# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PROJECT=<YOUR PROJECT ID> aquí el nombre del proyecto
REGION=us-central1
QUERY="SELECT * FROM data_playground.transactions"

PIPELINE_ROOT=gs://$PROJECT/pipeline_local
PIPELINE_NAME=fraud-detect-pipeline
TRANSFORM_FN=./my_vertex_pipelines/feature_engineering_fn.py
TRAINER_FN=./my_vertex_pipelines/trainer_fn.py

TEMP_LOCATION=gs://$PROJECT/tmp/

cd fraud-detection-pipelines || exit

VERSION=$(python setup.py --version)
LOCAL_PACKAGE=dist/fraud-detection-pipelines-$VERSION.tar.gz

python setup.py sdist

pip install $LOCAL_PACKAGE

python -m my_vertex_pipelines.fraud_detection_main --project-id=$PROJECT \
  --region=$REGION \
  --query="$QUERY" \
  --pipeline-roo=$PIPELINE_ROOT \
  --pipeline-name=$PIPELINE_NAME \
  --transform-fn-path=$TRANSFORM_FN \
  --trainer-fn-path=$TRAINER_FN \
  --temp-location=$TEMP_LOCATION \
  --run-locally