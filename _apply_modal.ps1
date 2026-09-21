# Convert inline #formView -> modal #formModal. CRLF+UTF-8(noBOM) preserved.
# Asserts first; apply top-to-bottom with line offset.
$p = "d:\xampp\htdocs\budgetting\www\index.html"
$lines = Get-Content -LiteralPath $p -Encoding utf8
function Assert-Line {
    param([int]$num, [string]$expected)
    $actual = $lines[$num - 1]
    if (($actual.TrimEnd()) -cne ($expected.TrimEnd())) { throw "ASSERT FAIL line $num`n  exp: [$expected]`n  act: [$actual]" }
}
function Apply([int]$start, [int]$end, [string]$newBlock) {
    $newArr = ($newBlock -replace "`r`n", "`n").Trim("`n") -split "`n"
    $s = $start - 1 + $offset; $e = $end - 1 + $offset
    $before = $lines[0..($s - 1)]
    if ($e -ge $lines.Count - 1) { $after = @() } else { $after = $lines[($e + 1)..($lines.Count - 1)] }
    $lines = $before + $newArr + $after
    $offset += ($newArr.Count - ($end - $start + 1))
}
$offset = 0
# ---- PASS 1: assert all target lines (file untouched) ----
Assert-Line 2690 "        document.addEventListener('click', function (event) {"
Assert-Line 2691 "            if (event.target && event.target.classList && event.target.classList.contains('modal-overlay')) {"
Assert-Line 2694 "        });"
Assert-Line 2439 "                /* Balik ke form project baru, isian user tetap ada */"
Assert-Line 2441 "                showView('formView');"
Assert-Line 2442 "                return;"
Assert-Line 2077 "            berangkatAutoFilled = false;"
Assert-Line 2079 "            showView('formView');"
Assert-Line 2080 "        }"
Assert-Line 2018 "            renderBudgeting();"
Assert-Line 2019 "            showView('budgetingView');"
Assert-Line 1717 "        function cancelNewProject() {"
Assert-Line 1733 "            showView('listView');"
Assert-Line 1734 "        }"
Assert-Line 1682 "            showView('formView');"
Assert-Line 1363 "            ['listView', 'formView', 'budgetingView'].forEach(function (id) {"
Assert-Line 1075 '            <div class="action-bar">'
Assert-Line 1076 '                <button class="btn btn-secondary" onclick="cancelNewProject()">Batal</button>'
Assert-Line 1080 '        </div>'
Assert-Line 992 '        <div id="formView" class="hidden">'
Assert-Line 997 '                    <div class="card-title" id="formCardTitle">Project Baru</div>'
Assert-Line 998 '                </div>'
Write-Host "Assertions OK"
# ---- PASS 2: apply (increasing line order) ----
Apply 989 998 @'
        <!-- ================================================
             LANGKAH 1 - FORM NEW PROJECT (modal di atas listView)
         ================================================= -->
        <div id="formModal" class="modal-overlay">

            <div class="modal">

                <div class="modal-header">
                    <div class="modal-title" id="formCardTitle">Project Baru</div>
                    <button class="modal-close" onclick="cancelNewProject()">&times;</button>
                </div>

                <div class="modal-body">
'@
Apply 1073 1080 @'
                </div>

                <div class="modal-footer">
                    <button class="btn btn-secondary" onclick="cancelNewProject()">Batal</button>
                    <button class="btn btn-primary" onclick="goToBudgeting()">Next</button>
                </div>

            </div>
        </div>
'@
Apply 1363 1363 @'
            ['listView', 'budgetingView'].forEach(function (id) {
'@
Apply 1682 1682 @'
            openModal('formModal');
'@
Apply 1717 1734 @'
        function cancelNewProject() {
            /* Form sekarang modal yang mengambang di atas listView/budgetingView,
               jadi tombol Batal (atau backdrop) cukup menutup modal saja;
               view di belakang tidak perlu disembunyikan lagi. */
            if (editingExisting && draftProject) {
                closeModal('formModal');
                return;
            }

            resetNewProjectForm();

            draftProject = null;
            draftIsNew = false;
            editingExisting = false;
            currentProjectId = null;

            renderProjectList();
            closeModal('formModal');
        }
'@
# 4) goToBudgeting add closeModal (2018-2019)
Apply 2018 2019 @'
            renderBudgeting();
            closeModal('formModal');
            showView('budgetingView');
'@
# 3) editProjectInfo openModal (2079)
Apply 2079 2079 @'
            openModal('formModal');
'@
# 2) cancelBudgeting wasNew -> show list + open modal (2438-2443)
Apply 2438 2443 @'
            if (wasNew) {
                /* Balik ke form project baru, isian user tetap ada */
                renderProjectList();
                showView('listView');
                openModal('formModal');
                return;
            }
'@
# 1) backdrop click listener (2690-2694)
Apply 2690 2694 @'
        document.addEventListener('click', function (event) {
            if (event.target && event.target.classList && event.target.classList.contains('modal-overlay')) {
                /* Klik backdrop di luar form modal = batal (reset state) agar konsisten,
                   bukan sekitar remove class. Modal lain (mis. Hapus Item) tetap langsung tertutup. */
                if (event.target.id === 'formModal') {
                    cancelNewProject();
                } else {
                    event.target.classList.remove('active');
                }
            }
        });
'@

# ---- pre-write guard ----
$fv = ($lines -match 'formView').Count
$fm = ($lines -match 'formModal').Count
if ($fv -ne 0) { throw "PRE-WRITE GUARD FAIL: formView still referenced $fv times" }
if ($fm -le 0) { throw "PRE-WRITE GUARD FAIL: formModal not found" }

# ---- write back: CRLF + UTF-8 (NO BOM) ----
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines($p, $lines, $utf8NoBom)

# ---- verify ----
$f = Get-Content -LiteralPath $p -Encoding utf8
Write-Host "ALL EDITS APPLIED OK"
Write-Host "total lines = $($f.Count)"
Write-Host "formView refs (expect 0)  = $(($f -match 'formView').Count)"
Write-Host "formModal refs (expect >0) = $(($f -match 'formModal').Count)"
$be = [IO.File]::ReadAllBytes($p)
if ($be[0] -eq 239 -and $be[1] -eq 183 -and $be[2] -eq 191) { Write-Host "BOM = WITH-BOM (unexpected)" } else { Write-Host "BOM = none (OK)" }
if ($be -contains 13) { Write-Host "line endings = CRLF (OK)" } else { Write-Host "line endings = LF (unexpected)" }

