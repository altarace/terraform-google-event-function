/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "google_pubsub_topic" "main" {
  name    = "${var.name}"
  labels  = "${var.labels}"
  project = "${var.project_id}"
}

resource "google_logging_project_sink" "main" {
  name                   = "${var.name}"
  destination            = "pubsub.googleapis.com/${google_pubsub_topic.main.id}"
  filter                 = "${var.filter}"
  project                = "${var.project_id}"
  unique_writer_identity = true
}

resource "google_pubsub_topic_iam_member" "main" {
  topic   = "${google_pubsub_topic.main.name}"
  project = "${google_logging_project_sink.main.project}"
  member  = "${google_logging_project_sink.main.writer_identity}"
  role    = "roles/pubsub.publisher"
}
