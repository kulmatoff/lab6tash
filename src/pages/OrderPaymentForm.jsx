import { useState } from "react";

const OrderPaymentForm = () => {
  const [orderId, setOrderId] = useState("");
  const [amount, setAmount] = useState("");
  const [paymentTypeId, setPaymentTypeId] = useState("1");
  const [comment, setComment] = useState("");
  const [result, setResult] = useState(null);
  const token = localStorage.getItem("token");

  const handleSubmit = async (e) => {
    e.preventDefault();

    const response = await fetch("http://localhost:5000/api/payments/add", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        Order_ID: parseInt(orderId),
        Amount: parseFloat(amount),
        Payment_Type_ID: parseInt(paymentTypeId),
        Comment: comment,
      }),
    });

    const data = await response.json();
    setResult(data);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-rose-100 via-pink-200 to-rose-100 px-6 py-12 flex items-center justify-center font-serif text-rose-900">
      <div className="w-full max-w-xl bg-white/60 backdrop-blur-lg border border-rose-300 p-10 rounded-3xl shadow-2xl">
        <h2 className="text-5xl font-extrabold mb-8 text-center tracking-wide drop-shadow-md">
          💳 Оплата заказа
        </h2>

        <form onSubmit={handleSubmit} className="space-y-6">
          <input
            className="w-full p-4 rounded-xl bg-rose-50/70 border border-rose-300 placeholder:text-rose-400 text-rose-900 focus:outline-none focus:ring-2 focus:ring-pink-400"
            placeholder="ID заказа"
            value={orderId}
            onChange={(e) => setOrderId(e.target.value)}
            required
          />

          <input
            type="number"
            className="w-full p-4 rounded-xl bg-rose-50/70 border border-rose-300 placeholder:text-rose-400 text-rose-900 focus:outline-none focus:ring-2 focus:ring-pink-400"
            placeholder="Сумма оплаты"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
            required
          />

          <select
            value={paymentTypeId}
            onChange={(e) => setPaymentTypeId(e.target.value)}
            className="w-full p-4 rounded-xl bg-rose-50/70 border border-rose-300 text-rose-900 focus:outline-none focus:ring-2 focus:ring-pink-400"
          >
            <option value="1">Наличные</option>
            <option value="2">Карта</option>
          </select>

          <input
            className="w-full p-4 rounded-xl bg-rose-50/70 border border-rose-300 placeholder:text-rose-400 text-rose-900 focus:outline-none focus:ring-2 focus:ring-pink-400"
            placeholder="Комментарий"
            value={comment}
            onChange={(e) => setComment(e.target.value)}
          />

          <button
            type="submit"
            className="w-full py-3 bg-gradient-to-r from-pink-400 to-rose-300 hover:brightness-110 transition-all duration-300 rounded-full font-bold text-rose-900 shadow-lg"
          >
            🌸 Оплатить
          </button>
        </form>

        {result && (
          <div
            className={`mt-8 p-4 rounded-xl text-center font-semibold ${
              result.success
                ? "bg-green-200/40 border border-green-400 text-green-800"
                : "bg-red-200/40 border border-red-400 text-red-800"
            }`}
          >
            {result.success ? "✅ Оплата прошла успешно!" : `❌ Ошибка: ${result.message}`}
          </div>
        )}
      </div>
    </div>
  );
};

export default OrderPaymentForm;
