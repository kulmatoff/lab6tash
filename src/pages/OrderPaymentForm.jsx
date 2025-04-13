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
        Authorization: `Bearer ${token}`
      },
      body: JSON.stringify({
        Order_ID: parseInt(orderId),
        Amount: parseFloat(amount),
        Payment_Type_ID: parseInt(paymentTypeId),
        Comment: comment
      })
    });

    const data = await response.json();
    setResult(data);
  };

  return (
    <div className="p-6 max-w-xl mx-auto bg-white rounded shadow">
      <h2 className="text-2xl font-bold mb-4">💳 Оплата заказа</h2>
      <form onSubmit={handleSubmit} className="space-y-4">
        <input className="w-full p-2 border" placeholder="Order ID" value={orderId} onChange={e => setOrderId(e.target.value)} required />
        <input className="w-full p-2 border" placeholder="Сумма" type="number" value={amount} onChange={e => setAmount(e.target.value)} required />
        <select className="w-full p-2 border" value={paymentTypeId} onChange={e => setPaymentTypeId(e.target.value)}>
          <option value="1">Наличные</option>
          <option value="2">Карта</option>
        </select>
        <input className="w-full p-2 border" placeholder="Комментарий" value={comment} onChange={e => setComment(e.target.value)} />
        <button type="submit" className="bg-blue-500 text-white p-2 rounded">Оплатить</button>
      </form>

      {result && (
        <div className="mt-4 bg-green-100 p-2 rounded">
          {result.success ? "Оплата прошла успешно!" : `Ошибка: ${result.message}`}
        </div>
      )}
    </div>
  );
};

export default OrderPaymentForm;
