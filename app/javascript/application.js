// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

document.addEventListener("DOMContentLoaded", () => {
  const prefectureSelect = document.querySelector("#spot_prefecture_id");

  if (prefectureSelect) {
    prefectureSelect.addEventListener("change", () => {
      const prefectureId = prefectureSelect.value;

      if (prefectureId) {
        const url = `/municipalities?prefecture_id=${prefectureId}`;

        fetch(url, {
          headers: { Accept: "text/vnd.turbo-stream.html" }
        })
        .then((response) => response.text())
        .then((html) => {
          // 最新の municipality_select_frame を取得して、HTMLを挿入
          const municipalityFrame = document.querySelector("#municipality_select_frame");
          if (municipalityFrame) {
            municipalityFrame.innerHTML = html;
          } else {
            console.error("municipality_select_frame の要素が見つかりません");
          }
        })
        .catch((error) => {
          console.error("エラーが発生しました:", error);
        });
      }
    });
  }
});