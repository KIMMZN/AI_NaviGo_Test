from openpyxl import load_workbook

def remove_faulty_styles(input_file: str, output_file: str):
    wb = load_workbook(input_file)  # 여기서 에러가 날 수 있으므로, read_only=True를 같이 써볼 수도 있습니다.
    # 문제의 named_styles를 전부 비워버립니다.
    wb.named_styles = []
    wb.save(output_file)
    print(f"✅ 저장 완료: {output_file}")

if __name__ == "__main__":
    input_path = "data/한국관광공사_국문_서비스분류코드_v4.2_gs.xlsx"
    output_path = "data/final_fixed.xlsx"
    remove_faulty_styles(input_path, output_path)